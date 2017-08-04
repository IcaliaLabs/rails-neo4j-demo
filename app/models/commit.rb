class Commit
  include Neo4j::ActiveNode
  id_property :sha

  property :commit_message, type: String
  property :commit_date, type: DateTime
  property :author_date, type: DateTime

  has_many :in,  :childs,  origin: :is_child_of, model_class: :Commit
  has_many :out, :parents, type: :is_child_of,   model_class: :Commit
end

# It's not a tree, it's a DAG!
