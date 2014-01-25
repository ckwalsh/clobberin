class TimeController < ApplicationController
  def index
    @now = Time.now
    @timezone = get_timezone(nil)
    @zones = Timezone::Zone.names.sort.collect do |x|
      [x.gsub(/\//, ': ').gsub(/_/, ' '), x]
    end
  end

  def create
    h = (params[:h] || 8).to_i
    h = 8 if h < 0 || h > 23
    if h > 0 && h < 13
      h += 12 if params[:p] == 'PM'
    end
    t = Time.utc(
      (params[:y] || Time.now.year).to_i,
      (params[:o] || 1).to_i,
      (params[:d] || 1).to_i,
      h,
      (params[:m] || 1).to_i
    )

    tz = get_timezone(params[:tz])

    t -= tz.utc_offset(t)

    redirect_to :action => :view, :ts => t.to_i

  end

  def about
  end

  def view
    @timezone = get_timezone(params[:tz])
    ts = params[:ts] || Time.now
    ts = ts.to_i
    @time = Time.at(ts)
    @time_tz = @timezone.time(@time)
    @zones = Timezone::Zone.names.sort.collect do |x|
      [x.gsub(/\//, ': ').gsub(/_/, ' '), x]
    end
    @show_current_loc = !params[:tz].nil?
  end

  private

  def get_timezone(tz)
    if tz.nil?
      geoip = GeoIP.new('GeoLiteCity.dat')
      city = geoip.city(request.remote_ip)
      puts city.inspect
      return city.nil? ? Timezone::Zone.new(:zone => 'America/Los_Angeles') : Timezone::Zone.new(:latlon => [city.latitude, city.longitude])
    else
      return Timezone::Zone.new :zone => tz
    end
  end
end
