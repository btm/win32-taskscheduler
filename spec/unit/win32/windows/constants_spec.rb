require 'spec_helper'
require 'win32/taskscheduler'
require 'win32/windows/constants'

RSpec.describe Win32::TaskScheduler, :windows_only do
  describe 'Ensuring trigger constants' do
    subject(:ts) { Win32::TaskScheduler }
    describe 'to handle scheduled tasks' do
      [:ONCE, :DAILY, :WEEKLY, :MONTHLYDATE, :MONTHLYDOW].each do |const|
        it { should be_const_defined(const) }
      end
    end

    describe 'to handle other types' do
      [:AT_LOGON, :AT_SYSTEMSTART, :ON_IDLE].each do |const|
        it { should be_const_defined(const) }
      end
    end
  end
end
