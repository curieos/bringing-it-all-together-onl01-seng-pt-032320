class Dog
  attr_reader :id
  attr_accessor :name, :breed
  
  def initialize(id: nil, name: String, breed: String)
    @id = id
    @name = name
    @breed = breed
  end
  
  def create_table
    sql <<-SQL
      CREATE TABLE IF NOT EXISTS dog (
        
      )
    SQL
    DB[:conn].execute(sql)
  end
end