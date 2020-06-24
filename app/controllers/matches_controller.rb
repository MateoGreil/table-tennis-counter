class MatchesController < InheritedResources::Base
  actions :all, except: :new
end
