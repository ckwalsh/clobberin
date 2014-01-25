# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $("#timezone_select").change ->
    url = '/' + $('#ts').val() + '/' + $('#timezone_select').val()
    document.location = url

$ ->
  $('#home_hour').change ->
    hour = Math.floor($('#home_hour').val())
    if hour < 1 || hour > 12
      $('#home_meridian').attr('disabled', 1)
      if hour > 12
        $('#home_meridian').val('PM')
      else
        $('#home_meridian').val('AM')
    else
      $('#home_meridian').removeAttr('disabled')

@doCountdown = (target, now) ->
  clientNow = new Date().getTime() / 1000
  clientTarget = clientNow - now + target
  minute = 60
  hour = minute * 60
  day = hour * 24
  updater = () ->
    remaining = Math.floor(clientTarget - (new Date().getTime() / 1000))
    text = ''
    
    if remaining > 0
      if remaining > day
        days = Math.floor(remaining / day)
        text = days + ' day'
        if days > 1
          text += 's'
        remaining = remaining % day
      
      if remaining > hour
        if text != ''
          text += ', '
        hours = Math.floor(remaining / hour)
        text += hours + ' hour'
        if hours > 1
          text += 's'
        remaining = remaining % hour
      
      if remaining > minute
        if text != ''
          text += ', '
        minutes = Math.floor(remaining / minute)
        text += minutes + ' minute'
        if minutes > 1
          text += 's'
        remaining = remaining % minute

      if remaining > 0
        if text != ''
          text += ', '
        text += remaining + ' second';
        if remaining > 1
          text += 's'

       text += ' until...'
    else
      text = "Time's Up!";

    div = $('#countdown')
    if (div.text() != text)
      div.text(text)

  handle = setInterval updater, 100
