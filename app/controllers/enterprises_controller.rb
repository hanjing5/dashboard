class EnterprisesController < ApplicationController
  def index
    @payload = PstNetworkUser.group(:pstNetworkAccountOid).count
  end

  def show
  end

  # giving a corporation, tells us daily, weekly, or monthly change
  # of traffic referals
  # corporations are identified by activation codes
  def show
    # make sure we grab the info also
    # given the activation code, we want to see the tags
    #@info = PstActivationCode.
      # group by activation code AND (createDatetime) then do count?
  end

  def daily
      # takes in an activation code and group the appearance by date
    @title = 'Daily'
    @payload = PstNetworkUser.where("pstNetworkAccountOid==#{params[:id]}").group("date(createDatetime)").count
    @max_value_pair =  @payload.max_by{|k, v| v}
  end

  def weekly 
      # takes in an activation code and group the appearance by week

    @title = 'Weekly'
    @payload = PstNetworkUser.where("pstNetworkAccountOid==#{params[:id]}").group("week(createDatetime)").count
    @max_value_pair =  @payload.max_by{|k, v| v}
  end

  def monthly 
      # takes in an activation code and group the appearance by month
    @title = 'Monthly'
    @payload = PstNetworkUser.where("pstNetworkAccountOid='#{params[:id]}'").group("month(createDatetime)").count
    @max_value_pair =  @payload.max_by{|k, v| v}
  end

  # percentage change day to day
  # stats and prediction analysis
  def daytoday
    @title = 'Day to Day'
    @daytoday = true;
    @payload = PstNetworkUser.group("week(createDatetime)").sum(:fileSize)
    @max_value_pair =  @payload.max_by{|k, v| v}
  end

  def mvp
    # this should give us the top 5 companies that are providing
    # us the most traffic and how much traffic it is providing us
    # model.group.orderby(top amount).limit(5)
    @payload = PstNetworkUser.group(:pstNetworkAccountOid)
    @max_value_pair =  @payload.max_by{|k, v| v}
  end

end
