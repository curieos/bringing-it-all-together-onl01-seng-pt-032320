class Dog
  attr_reader :id
  attr_accessor :name, :breed
  
  def initialize(id: nil, name: String, breed: String)
    @id = id
    @name = name
    @breed = breed
  end
  
  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS dogs (
        id INTEGER PRIMARY KEY, 
        name TEXT, 
        breed TEXT
      )
    SQL
    DB[:conn].execute(sql)
  end
  
  def self.drop_table
    sql = <<-SQL
      DROP TABLE IF EXISTS dogs
    SQL
    DB[:conn].execute(sql)
  end
  
  def save
    sql = <<-SQL
      INSERT INTO dogs (name, breed) 
      VALUES (?, ?)
    SQL
    
    DB[:conn].execute(sql, self.name, self.breed)
    
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
    self
  end
  
  def self.create(name: String, breed: String)
    Dog.new(name: name, breed: breed).save()
  end
  
  def self.new_from_db(row)
    Dog.new(id: row[0], name: row[1], breed: row[2])
  end
  
  def self.find_by_id(id)
    sql = <<-SQL
      SELECT * FROM dogs
      WHERE id = ?
    SQL
    
    rawDog = DB[:conn].execute(sql, id)
    
    Dog.new(id: rawDog[0][0], name: rawDog[0][1], breed: rawDog[0][2])
  end
  
  def self.find_or_create_by(name: String, breed: String)
    sql = <<-SQL
      SELECT * FROM dogs
      WHERE name = ?
      AND breed = ?
    SQL
    
    rawDog = DB[:conn].execute(sql, name, breed)
    
    dog = Dog.new(
      id: rawDog[0] ? rawDog[0][0] : nil,
      name: rawDog[0] ? rawDog[0][1] : name,
      breed: rawDog[0] ? rawDog[0][1] : breed
    )
    
    dog.save() if rawDog[0]
  end
end