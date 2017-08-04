class CreateCommitShaConstraint < Neo4j::Migrations::Base
  def up
    add_constraint :Commit, :sha
  end

  def down
    drop_constraint :Commit, :sha
  end
end
