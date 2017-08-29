#!/usr/bin/env ruby
# frozen_string_literal: true

require 'chef-api'
require 'json'
require 'httparty'

headers = {}

keypath = ENV['KEYPATH'].nil? ? '/chef-usage' : ENV['KEYPATH']
client = ENV['CHEF_CLIENT'].nil? ? 'pivotal' : ENV['CHEF_CLIENT']
flavor = ENV['ENTERPRISE'] ? :enterprise : :open_source

data = JSON.parse(ARGV[0])

org_list_connection = ChefAPI::Connection.new(
  endpoint: ENV['CHEF_SERVER_URL'],
  flavor: flavor,
  client: client,
  key: "#{keypath}/#{client}.pem"
)

orgs = org_list_connection.organizations.list

node_list = []
total = 0

orgs.each do |org|
  org_connection = ChefAPI::Connection.new(
    endpoint: "#{ENV['CHEF_SERVER_URL']}/organizations/#{org}",
    flavor: flavor,
    client: client,
    key: "#{keypath}/#{client}.pem"
  )
  node_list.push("#{org} : #{org_connection.nodes.count}\n")
  total += org_connection.nodes.count
end

node_list.push("===========================\n")
node_list.push("Total Node Count : #{total}")

HTTParty.post(
  "http://#{ENV['BOT_URL']}/v1/attachment",
  body: {
    'channel' => data['channel'],
    'attachments' =>
      {
        'fallback' => 'Chef Node List by Org',
        'title' => 'Chef Node Count by Org',
        'text' => node_list.join
      }
  },
  headers: headers
)

nil
