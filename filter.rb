#!/bin/env ruby
# frozen_string_literal: true

require 'gmail-britta'

GITHUB_NOTIFICATION = "from:notifications@github.com"
GITHUB_USERNAME = "@jtgrenz"
AUTHOR = { name: "Jon G", email: "jon.g@shopify.com" }
GITHUB_ME_EMAILS = %w(mention@noreply.github.com
                      assign@noreply.github.com
                      author@noreply.github.com)
GITHUB_AT_ME_EMAILS = { or: GITHUB_ME_EMAILS.map { |email| "cc:#{email}" } }

github_filterset = GmailBritta.filterset(author: AUTHOR, me: GITHUB_ME_EMAILS) do
  filter do
    has [GITHUB_NOTIFICATION, { and: GITHUB_AT_ME_EMAILS }]
    label "@GH/@Me"
  end.otherwise do
    has %W(#{GITHUB_NOTIFICATION} cc:manual@noreply.github.com)
    label "@GH/Manual Sub"
  end.otherwise do
    has %W(#{GITHUB_NOTIFICATION} @Shopify/Api-Patterns-Team)
    label "@GH/@Api-Patterns-Team"
  end.archive_unless_directed

  filter do
    has [GITHUB_NOTIFICATION, { and: 'cc:review_requested@noreply.github.com' }]
    label "@GH/Review"
  end

  filter do
    has [GITHUB_NOTIFICATION, { and: 'cc:team_mention@noreply.github.com' }]
    label "@GH/team"
  end.archive_unless_directed
end

File.write('gmail_github_filters.xml', github_filterset.generate)
