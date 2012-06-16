class PagesController < ApplicationController
    time_range = (Time.now.midnight - 1.day)..Time.now.midnight
    
  def index
      @daily = PstNetworkUser.group("date(createDatetime)").count
      @weekly = PstNetworkUser.group("week(createDatetime)").count
      @monthly = PstNetworkUser.group("month(createDatetime)").count

    @total_users = PstNetworkUser.all.count
    @this_month = PstNetworkUser.find(:all, :conditions => { :createDatetime => Date.today-30...Date.today }).count
    last_month = PstNetworkUser.find(:all, :conditions => { :createDatetime => Date.today-61...Date.today-31})
    this_month = PstNetworkUser.find(:all, :conditions => { :createDatetime => Date.today-30...Date.today })

    @month_percentage = to_percentage(last_month, this_month)
  end

  def users_quick_stats
    # should have
    # total user 
    @total_users = PstNetworkUser.select(:email).uniq.count
    # Growth from yesterday
    yesterday = PstNetworkUser.find(:all, :conditions => { :createDatetime => Date.today-3...Date.today-2})
    today = PstNetworkUser.find(:all, :conditions => { :createDatetime => Date.today-2...Date.today-1})

    @yesterday_percentage = to_percentage(yesterday, today)

    # Growth from last 7 days
    last_week = PstNetworkUser.find(:all, :conditions => { :createDatetime => Date.today-15...Date.today-8 })
    this_week = PstNetworkUser.find(:all, :conditions => { :createDatetime => Date.today-7...Date.today })

    @week_percentage = to_percentage(last_week, this_week)
    
    # Growth from last 30 days
    last_month = PstNetworkUser.find(:all, :conditions => { :createDatetime => Date.today-61...Date.today-31})
    this_month = PstNetworkUser.find(:all, :conditions => { :createDatetime => Date.today-30...Date.today })

    @month_percentage = to_percentage(last_month, this_month)

    # Growth from last 365 days
    last_year = PstNetworkUser.find(:all, :conditions => { :createDatetime => Date.today-731...Date.today-366})
    this_year = PstNetworkUser.find(:all, :conditions => { :createDatetime => Date.today-365...Date.today})

    @year_percentage = to_percentage(last_year, this_year)
  end

  def users
      id = params[:id]
      
      @payload = ''
      if id == 'daily'
        @title = 'Daily'
        @payload = PstNetworkUser.group("date(createDatetime)").limit(90).count

      elsif id =='weekly'
        @title = 'Weekly'
        @payload = PstNetworkUser.group("week(createDatetime)").count
        
      elsif id == 'monthly'
        @title = 'Monthly'
        @payload = PstNetworkUser.group("month(createDatetime)").count
    elsif id == 'source'
        @title = 'Source'
        tmp = PstActivationCode.group(:activationCode).count
        @payload = tmp.dup
        @payload.each do |k, v|
            if v > 1000
                @payload[k] = 100
            end
        end
        @desc = PstActivationCode.all
    elsif id == 'quick'
        redirect_to pages_users_quick_stats_path
        return
      end

      @max_value_pair =  @payload.max_by{|k, v| v}
  end

  def storage
      id = params[:id]
      
      @payload = ''
      if id == 'daily'
        @title = 'Daily'
        @payload = PstResource.group("date(createDatetime)").limit(90).sum(:fileSize)
      elsif id =='weekly'
        @title = 'Weekly'
        @payload = PstResource.group("week(createDatetime)").sum(:fileSize)
        
      elsif id == 'monthly'
        @title = 'Monthly'
        @payload = PstResource.group("month(createDatetime)").sum(:fileSize)
      elsif id =='daytoday'
        @title = 'Day to Day'
        @daytoday = true;
        @payload = PstResource.group("week(createDatetime)").sum(:fileSize)
      elsif id == 'quick'
        redirect_to pages_storage_quick_stats_path
      end

      @max_value_pair =  @payload.max_by{|k, v| v}
  end

  def storage_quick_stats
    # should have
    # total user 
    model =PstResource 
    @total_payload= model.all.count
    # Growth from yesterday
    yesterday = model.sum(:fileSize, :conditions => { :createDatetime => Date.today-2...Date.today-1})
    today = model.find(:all, :conditions => { :createDatetime => Date.today-1...Date.today})

    @yesterday_percentage = to_percentage(yesterday, today)

    # Growth from last 7 days
    last_week = model.sum(:fileSize, :conditions => { :createDatetime => Date.today-15...Date.today-8})
    this_week = model.sum(:fileSize, :conditions => { :createDatetime => Date.today-7...Date.today})

    @week_percentage = to_percentage(last_week, this_week)
    
    # Growth from last 30 days
    last_month = model.sum(:fileSize, :conditions => { :createDatetime => Date.today-61...Date.today-31})
    this_month = model.sum(:fileSize, :conditions => { :createDatetime => Date.today-30...Date.today})

    @month_percentage = to_percentage(last_month, this_month)

    # Growth from last 365 days
    last_year = model.sum(:fileSize, :conditions => { :createDatetime => Date.today-731...Date.today-366})
    this_year = model.sum(:fileSize, :conditions => { :createDatetime => Date.today-365...Date.toda})

    @year_percentage = to_percentage(last_year, this_year)
  end

  # giving a corporation, tells us daily, weekly, or monthly change
  # of traffic referals
  # corporations are identified by activation codes
  def corps
      id = params[:id]
      
        # make sure we grab the info also
        # given the activation code, we want to see the tags
        #@info = PstActivationCode.
      # group by activation code AND (createDatetime) then do count?
      model = PstNetworkUser 
      @payload = ''
      if id == 'daily'
        @title = 'Daily'
        @payload = model.group("date(createDatetime)").limit(90).sum(:fileSize)
      elsif id =='weekly'
        @title = 'Weekly'
        @payload = model.group("week(createDatetime)").sum(:fileSize)
        
      elsif id == 'monthly'
        @title = 'Monthly'
        @payload = model.group("month(createDatetime)").sum(:fileSize)
      elsif id =='daytoday'
        @title = 'Day to Day'
        @daytoday = true;
        @payload = model.group("week(createDatetime)").sum(:fileSize)

    # this should give us the top 5 companies that are providing
    # us the most traffic and how much traffic it is providing us
      elsif id == 'mvp'
          # model.group.orderby(top amount).limit(5)
        @payload = PstNetworkUser.group(:activationCode)

      elsif id == 'quick'
        redirect_to pages_corp_quick_stats_path
        return
      end
      @max_value_pair =  @payload.max_by{|k, v| v}
  end

  def change
    base = params['chart']
    if base['daily']
      @payload = PstNetworkUser.group("date(createDatetime)")
        
    elsif base['weekly']
      @payload = PstNetworkUser.group("week(createDatetime)")

    elsif base['monthly']
      @payload = PstNetworkUser.group("month(createDatetime)")
    elsif base['source']
        @payload = PstNetworkUser.group(:activationCode)
    end

      @monthly = PstNetworkUser.group("month(createDatetime)")
      respond_to do |format|
          format.js
          format.html
      end
  end

  def new
  end

  def show
  end

  private
    def to_percentage(new, old)
        return (new.count.to_f-old.count.to_f)/old.count.to_f * 100
    end
end
