class WelcomeController < ApplicationController
  def homepage
    redirect_to :messages
    # TODO landing page: messages + rules = activities
    #                    how to write rules with/out regex
    #                    explain structure of activities
    #                      maybe recommend 'bik' instead of 'biking|biked'
    #                      and 'butter' insead of 'butterlap|butter lap'
    #                    collect email of interest
  end
end
