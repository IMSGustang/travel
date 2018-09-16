module VariableHelper
  def self.api_url
    return Rails.env.development? ? 'http://apiv3.abutours.com/v1/' : 'http://api2.abutours.com/v1/'
    # return Rails.env.development? ? 'http://localhost:3001/v1/' : 'http://api2.abutours.com/v1/'
    session['access_token']
  end

  def self.api_url_ppob
    api_url + 'ppob/'
  end

  def api_url
    return Rails.env.development? ? 'http://apiv3.abutours.com/v1/' : 'http://api2.abutours.com/v1/'
    # return Rails.env.development? ? 'http://localhost:3001/v1/' : 'http://api2.abutours.com/v1/'
    session['access_token']
  end

  def clientId
    return '1cec286c6a4078358e12f5324c33aaed5486170a950ef893f13b78e096141d6f'
  end

  def self.clientId
    return '1cec286c6a4078358e12f5324c33aaed5486170a950ef893f13b78e096141d6f'
  end

  def self.cd(time)
    # Time Invoice
    time_invoice_not_parsed = Time.parse(time)
    time_invoice = time_invoice_not_parsed.to_formatted_s(:db)

    # Time Now
    time_now_not_parsed = Time.now
    time_now = time_now_not_parsed.to_formatted_s(:db)

    a = Time.parse(time_invoice)
    b = Time.parse(time_now)

    t = a - b

    mm, ss = t.divmod(60) #=> [4515, 21]
    hh, mm = mm.divmod(60) #=> [75, 15]
    dd, hh = hh.divmod(24) #=> [3, 3]
    return "%d/ %d:%d:%d" % [dd, hh, mm, ss]
  end

  def self.timeCleanParsing(time)
    # Time Invoice
    time_invoice_not_parsed = Time.parse(time)
    time_invoice = time_invoice_not_parsed.to_formatted_s(:db)

    return time_invoice
  end

  def self.log(error, url)
    open('public/error_log.txt', 'a+') do |f|
        f.puts "-----------------------------------"
        f.puts "|           ERROR LOG             |"
        f.puts "-----------------------------------"
        f.puts "Tanggal : "+Time.new.to_s
        f.puts "Keterangan : " + error.to_s
        f.puts "URL : "+url.to_s
        f.puts ""
      end
  end
end