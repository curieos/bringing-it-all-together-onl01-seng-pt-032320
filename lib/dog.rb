class Dog
  attr_reader :id
  attr_accessor :name, :breed
  
  def initialize(id: nil, name: String, breed: String)
    @id = id
    @name = name
    @breed = breed
  end
  
  def self.create_table()
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS dog (
        id INTEGER PRIMARY KEY, 
        name TEXT, 
        breed TEXT
      )
    SQL
    DB[:conn].execute(sql)
  end
end