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
    @total_users = PstNetworkUser.all.count
    # Growth from yesterday
    yesterday = PstNetworkUser.find(:all, :conditions => { :createDatetime => Date.today-2...Date.today-1})
    today = PstNetworkUser.find(:all, :conditions => { :createDatetime => Date.today-1...Date.today})

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
        @payload = PstNetworkUser.group("date(createDatetime)").count

      elsif id =='weekly'
        @title = 'Weekly'
        @payload = PstNetworkUser.group("week(createDatetime)").count
        
      elsif id == 'monthly'
        @title = 'Monthly'
        @payload = PstNetworkUser.group("month(createDatetime)").count
        elsif id == 'quick'
            redirect_to pages_users_quick_stats_path
            return
      end

      @max_value_pair =  @payload.max_by{|k, v| v}
  end

  def storage
  end
  def change
    base = params['chart']
    if base['daily']
      @payload = PstNetworkUser.group("date(createDatetime)")
        
    elsif base['weekly']
      @payload = PstNetworkUser.group("week(createDatetime)")

    elsif base['monthly']
      @payload = PstNetworkUser.group("month(createDatetime)")

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