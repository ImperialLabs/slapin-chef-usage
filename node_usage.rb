# frozen_string_literal: true

require 'chef-api'
require 'json'
require 'httparty'

headers = {}

data = JSON.parse(ARGV[0])

org_list_connection = ChefAPI::Connection.new(
  endpoint: ENV['CHEF_SERVER_URL'],
  flavor: ENV['ENTERPRISE'] ? :enterprise : :open_source,
  client: ENV['CHEF_CLIENT'] || 'pivotal',
  key: "/chef-usage/#{ENV['CHEF_CLIENT']}.pem",
  ssl_verify: false
)

orgs = org_list_connection.organization.list

node_list = []
total = 0

orgs.each do |org|
  org_connection = ChefAPI::Connection.new(
    endpoint: "#{ENV['CHEF_SERVER_URL']}/organization/#{org}",
    flavor: ENV['ENTERPRISE'] ? :enterprise : :open_source,
    client: ENV['CHEF_CLIENT'] || 'pivotal',
    key: "#{ENV['CHEF_CLIENT']}.pem",
    ssl_verify: false
  )
  node_list.push("#{org} : #{org_connection.nodes.count}\n")
  total += org_connection.nodes.count
end

node_list.push('===========================')
node_list.push("Total Node Count : #{total}")

HTTParty.post(
  "#{ENV['BOT_URL']}/v1/attachment",
  body: {
    'channel' => data['channel'],
    'attachments' =>
      {
        'fallback' => 'Chef Node List by Org',
        'title' => 'Chef Node Count by Org',
        'text' => node_list.to_s
      }
  },
  headers: headers
)
