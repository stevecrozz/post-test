provider = LinkProvider.new

Benchmark.bm(7) do |m|
  m.report("create:") do
    DB.create_table! :test1 do
      column :left_type, :varchar
      column :left_id, :integer
      column :right_type, :varchar
      column :right_id, :integer

      index :left_type
      index :left_id
      index :right_type
      index :right_id
    end
  end

  b = ProgressBar.create(title: "Inserts", starting_at: 0, total: INSERT_SIZE, output: STDERR)
  m.report("insert:") do
    (1..INSERT_SIZE).each do |i|
      b.progress = i
      DB[:test1].insert(provider.provide)
    end
  end
  b.finish

  last_right_id = DB[:test1].order(:right_id).last[:right_id]

  b = ProgressBar.create(title: "Reads", starting_at: 0, total: INSERT_SIZE, output: STDERR)
  m.report("read:") do
    (1..READ_SIZE).each do |i|
      b.progress = i
      resource_id = rand(last_right_id)
      DB[:test1].select_all.where(
        "(left_type = 'resource' AND left_id = #{resource_id}) OR (right_type = 'resource' AND right_id = #{resource_id})"
      ).all
    end
  end
  b.finish
end
