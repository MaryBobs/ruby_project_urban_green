require_relative("../db/sql_runner.rb")


class Category

  attr_reader :id
  attr_accessor :name

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @name = options['name']
  end

  def save()
    sql = "INSERT INTO categories
    (name)
    VALUES
    ($1)
    RETURNING id;"
    values = [@name]
    @id = SqlRunner.run(sql, values)[0]['id'].to_i
  end

  def update()
    sql = "UPDATE categories SET name = $1 WHERE id = $2;"
    values = [@name, @id]
    SqlRunner.run(sql, values)
  end

  def products()
    sql = "SELECT * FROM products WHERE id = $1"
    values = [@id]
    return SqlRunner.run(sql, values).map{|product| Product.new(product)}
  end

  def self.all()
    sql = "SELECT * FROM categories"
    result = SqlRunner.run(sql)
    return result.map{|category| Category.new(category)}
  end

  def self.find_by_id(id)
    sql = "SELECT * FROM categories WHERE id = $1"
    values = [id]
    return Supplier.new(SqlRunner.run(sql, values)[0])
  end

  def self.delete_all()
    sql = "DELETE FROM categories"
    SqlRunner.run(sql)
  end

  def self.delete_by_id(id)
    sql = "DELETE FROM categories WHERE id = $1"
    values = [id]
    SqlRunner.run(sql,values)
  end

end
