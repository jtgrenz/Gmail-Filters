#!/bin/env ruby
# frozen_string_literal: true

require 'gmail-britta'

filterset = GmailBritta.filterset do
  filter {
    has %w{list:robots@bigco.com subject:Important}
    label 'work/robots/important'
    # Do not archive
  }.otherwise {
    has %w{list:robots@bigco.com subject:Chunder}
    label 'work/robots/irrelevant'
  }.archive_unless_directed(:mark_read => true).otherwise {
    has %w{list:robots@bigco.com subject:Semirelevant}
    label 'work/robots/meh'
  }.archive_unless_directed
end

File.write('gmail_demo_filters.xml', filterset.generate)
