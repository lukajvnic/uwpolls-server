class Poll < ApplicationRecord
    before_create :set_defaults
  
    private
  
    def set_defaults
      self.res1 ||= 0
      self.res2 ||= 0
      self.res3 ||= 0
      self.res4 ||= 0
      self.totalvotes ||= 0
      self.timeposted ||= Time.current
    end
  end
  