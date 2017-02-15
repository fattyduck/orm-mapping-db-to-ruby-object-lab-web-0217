require 'pry'
class Student
  attr_accessor :id, :name, :grade

  def initialize(id = nil, name = nil, grade = nil)
    @id = id
    @name = name
    @grade = grade
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = 10
      ORDER BY id LIMIT 1
    SQL

    results = DB[:conn].execute(sql).flatten
    #binding.pry
    self.new(results[0],results[1], results[2])
  end

  def self.first_x_students_in_grade_10(x)
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = 10
      ORDER BY id LIMIT ?
    SQL
    rows = DB[:conn].execute(sql, x)
    rows.map! {|row| self.new(row[0], row[1], row[2])}

  end

  def self.all_students_in_grade_x(x)
    sql = "SELECT * FROM students WHERE grade = ?"
    rows = DB[:conn].execute(sql, x)
    rows.map! {|row| self.new(row[0], row[1], row[2])}
  end

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    student = self.new(row[0], row[1],row[2])
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = "SELECT * FROM students"
    rows = DB[:conn].execute(sql)
    rows.map! {|row| self.new(row[0], row[1], row[2])}
  end

  def self.count_all_students_in_grade_9
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = 9
    SQL

    DB[:conn].execute(sql)

  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade < 12
    SQL

    DB[:conn].execute(sql)
  end


  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
      SELECT * FROM students
      WHERE name = ?
    SQL

    results = DB[:conn].execute(sql, name).flatten
    student = self.new(results[0], results[1], results[2])

  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
