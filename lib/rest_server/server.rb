DB = Sequel.connect("jdbc:mysql://%s/%s?user=%s"% ["localhost","database_name","username"])

module RestServer 
  class Server < Sinatra::Base
    DB.tables.each do |table|
      puts table
      klass = Class.new(Sequel::Model(table))
  
      plural   = table.to_s.pluralize
  
      resources = "/#{table.to_s}"
      resource  = resources + "/:id"
  
      get(resources) do
        content_type :json
        klass.all.map(&:values).to_json
      end
  
      get(resource) do |id|
        content_type :json
        model = klass.find(:id => id)

        model ? model.values.to_json : 404
      end
  
      post(resources) do 
        content_type :json
        model = klass.create(params[plural])
        return 404 unless model

        model.errors.any? ? halt(404, model.errors) : model
      end
  
      put(resource) do |id|
        content_type :json

        model = klass.find( :id => id)
        return 404 unless model

        model.update(params[plural])

        model.errors.any? ? halt(404, model.errors): model.values.to_json
      end
  
      delete(resource) do |id|
        content_type :json

        model = klass.find(:id => id)
        return 404 unless model
        
        model.delete
      end
    end
  end
end
