class Pokemon
    attr_accessor :id, :name, :type, :db, :hp

    def initialize(id: nil, name:, type:, db:, hp: nil)
        @id = id
        @name = name
        @type = type
        @db = db
        @hp = hp
    end

    def self.save(name, type, db)
        sql = <<-SQL
            INSERT INTO pokemon (name, type)
            VALUES (?, ?)
        SQL

        db.execute(sql, name, type)

        @id = db.execute("SELECT last_insert_rowid() FROM pokemon")[0][0]
    end

    def self.new_from_db(row)
        Pokemon.new(id: row[0], name: row[1], type: row[2], db: self, hp: row[3])
    end

    def self.find(id, db)
        sql = <<-SQL
            SELECT * 
            FROM pokemon
            WHERE id = ?
        SQL

        db.execute(sql, id).map do |row|
            self.new_from_db(row)
        end.first
    end

    def alter_hp(hp, db)
        sql = <<-SQL
            UPDATE pokemon 
            SET hp = ? 
            WHERE id = ?
        SQL

        db.execute(sql, hp, self.id)
    end
end
