require 'bundler/setup'
Bundler.require

ActiveRecord::Base.establish_connection

class User < ActiveRecord::Base
    has_many :presents, foreign_key: "sendto_id"
end

class Present < ActiveRecord::Base
    belongs_to :sendto, class_name: "User"
end