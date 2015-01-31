require "sinatra"     # Load the Sinatra web framework
require "data_mapper" # Load the DataMapper database library

require "./database_setup"

class Book
  include DataMapper::Resource

  property :id,         Serial
  property :title,      String,   required: true
  property :created_at, DateTime, required: true
  
  has n, :tags, "Tag"
end

class Tag
  include DataMapper::Resource

  belongs_to :book,    Book
  belongs_to :subject, Subject
end

class Subject
  include DataMapper::Resource
  
  property :title,     String, required: true
  
  has n, :tags, "Tag"
end

DataMapper.finalize()
DataMapper.auto_upgrade!()

get("/") do
  records = Message.all(order: :created_at.desc)
  erb(:index, locals: { messages: records })
end

post("/messages") do
  message_body = params["body"]
  message_time = DateTime.now

  message = Message.create(body: message_body, created_at: message_time)

  if message.saved?
    redirect("/")
  else
    erb(:error)
  end
end
