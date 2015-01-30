provider = LinkProvider.new

Benchmark.bm(7) do |m|
  m.report("create:") do
    DB.create_table! :test1 do
      column :left_type, :varchar
      column :left_id, :integer
      column :right_type, :varchar
      column :right_id, :integer

      index :left_id
      index :right_id
    end
  end

  m.report("insert:") do
    (1..INSERT_SIZE).each do
      DB[:test1].insert(provider.provide)
    end
  end

  last_right_id = DB[:test1].order(:right_id).last[:right_id]

  m.report("read:") do
    (1..READ_SIZE).each do
      resource_id = rand(last_right_id)
      DB[:test1].select_all.where(
        "left_id = #{resource_id} OR right_id = #{resource_id}"
      ).all
    end
  end
end
