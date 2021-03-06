require 'json'

provider = LinkProvider.new

Benchmark.bm(7) do |m|
  m.report("create:") do
    DB.create_table! :test2 do
      primary_key :id
      column :content, :jsonb
    end

    DB << "CREATE INDEX idxlinkcontent ON test2 USING gin (content jsonb_path_ops)"
  end

  b = ProgressBar.create(title: "Inserts", starting_at: 0, total: INSERT_SIZE, output: STDERR)
  m.report("insert:") do
    (1..INSERT_SIZE).each do |i|
      b.progress = i
      link = provider.provide
      row = {
        content: JSON.dump([{
            "type" => link[:left_type],
            "id" => link[:left_id],
          }, {
            "type" => link[:right_type],
            "id" => link[:right_id],
          }
        ])
      }
      DB[:test2].insert(row)
    end
  end
  b.finish

  last_right_id = JSON.parse(DB[:test2].order(:id).last[:content])[1]["id"]

  b = ProgressBar.create(title: "Reads", starting_at: 0, total: INSERT_SIZE, output: STDERR)
  m.report("read:") do
    (1..READ_SIZE).each do |i|
      b.progress = i
      resource_id = rand(last_right_id)
      DB[:test2].select_all.where( sprintf('content @> \'[{ "id": %s, "type": "resource" }]\'', resource_id)).all
    end
  end
  b.finish
end
