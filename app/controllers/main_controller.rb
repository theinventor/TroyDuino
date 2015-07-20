class MainController < ApplicationController

  require 'open-uri'

  require 'json'
  TELEDUINO_KEY = "9EB1A6461DE6C8F5BC2999428B9E3D25"


  def turn_on num
    key = "9EB1A6461DE6C8F5BC2999428B9E3D25"

    base_url = "http://us01.proxy.teleduino.org/api/1.0/328.php?k=#{key}"
    three_on = "&r=setDigitalOutput&pin=3&output=1"
    three_off = "&r=setDigitalOutput&pin=3&output=0"
    five_on = "&r=setDigitalOutput&pin=5&output=1"
    five_off = "&r=setDigitalOutput&pin=5&output=0"
    seven_on = "&r=setDigitalOutput&pin=7&output=1"
    seven_off = "&r=setDigitalOutput&pin=7&output=0"


    if num == "red"
      buffer = open(base_url+three_on, "UserAgent" => "Ruby-Wget").read
      buffer = open(base_url+five_off, "UserAgent" => "Ruby-Wget").read
      buffer = open(base_url+seven_off, "UserAgent" => "Ruby-Wget").read
    elsif num == "yellow"
      buffer = open(base_url+five_on, "UserAgent" => "Ruby-Wget").read
      buffer = open(base_url+three_off, "UserAgent" => "Ruby-Wget").read
      buffer = open(base_url+seven_off, "UserAgent" => "Ruby-Wget").read
    elsif num == "green"
      buffer = open(base_url+seven_on, "UserAgent" => "Ruby-Wget").read
      buffer = open(base_url+five_off, "UserAgent" => "Ruby-Wget").read
      buffer = open(base_url+three_off, "UserAgent" => "Ruby-Wget").read
    end

  end


  def index
    base_url = "http://us01.proxy.teleduino.org/api/1.0/328.php?k=#{TELEDUINO_KEY}"
    if params[:three_output]
      query = "&r=definePinMode&pin=3&mode=1"
    elsif params[:three] == "on"
      query = "&r=setDigitalOutput&pin=3&output=1"
    elsif params[:three] == "off"
      query = "&r=setDigitalOutput&pin=3&output=0"
    elsif params[:five_output]
      query = "&r=definePinMode&pin=5&mode=1"
    elsif params[:five] == "on"
      query = "&r=setDigitalOutput&pin=5&output=1"
    elsif params[:five] == "off"
      query = "&r=setDigitalOutput&pin=5&output=0"
    elsif params[:six_output]
      query = "&r=definePinMode&pin=6&mode=1"
    elsif params[:six] == "on"
      query = "&r=setDigitalOutput&pin=6&output=1"
    elsif params[:six] == "off"
      query = "&r=setDigitalOutput&pin=6&output=0"
    elsif params[:seven_output]
      query = "&r=definePinMode&pin=7&mode=1"
    elsif params[:seven] == "on"
      query = "&r=setDigitalOutput&pin=7&output=1"
    elsif params[:seven] == "off"
      query = "&r=setDigitalOutput&pin=7&output=0"

    else
      query = "&r=getUptime"
    end

    @command = base_url + query
    buffer = open(@command, "UserAgent" => "Ruby-Wget").read
    @result = JSON.parse(buffer)
  end

  def poll

    url = "http://backoffice.repairshopr.com/api/get_ticket_aging/?api_key=#{ENV['DRPC_KEY']}"
    buffer = open(url, "UserAgent" => "Ruby-Wget").read
    result = JSON.parse(buffer)
    puts result

    puts "RED: #{result["aging_red"]}"
    puts "YELLOW: #{result["aging_yellow"]}"
    puts "NEED DIAG: #{result["need_diagnose"]}"

    if result["aging_red"].to_i > 0
      turn_on "red"
      puts "TURNING on red"
    elsif result["aging_yellow"].to_i > 0
      turn_on "yellow"
      puts "TURNING on yellow"
    elsif result["need_diagnose"].to_i > 0
      turn_on "yellow"
      puts "TURNING on yellow"
    else
      turn_on "green"
      puts "TURNING on green"
    end



    render json: result
  end

  def poll_ci

    url = "https://snap-ci.com/d9k9TQwbdHhWf-9yWNH5NscyiRWtIrP-CYtN5Ojm9yY/RepairShopr/RepairShopr/branch/master/cctray.xml"
    buffer = Faraday.get(url)

    result = Hash.from_xml(buffer.body)
    puts result

    last_status = 'Success'
    result['Projects']["Project"].each do |stage|
      next if stage['name'].include?("Internal")
      last_status = "Failure" unless stage['lastBuildStatus'] == "Success"
      break if stage['lastBuildStatus'] == "Failure"
    end

    begin
      if last_status == 'Success'
        turn_on 'green'
      else
        turn_on 'red'
      end
    rescue => ex
      render text: "EX: #{ex} --- #{ex.backtrace}" and return
      puts ex

    end

    render json: result
  end




end
