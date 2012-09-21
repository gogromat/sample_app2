module MicropostsHelper

  def wrap(content)
    #sanitize(raw(content.split.map{ |s| wrap_long_string(s) }.join(' ')))
    # raw - prevent HTML escaping
    # sanitize - cssx prevention
    sanitize(raw(wrap_long_string(content)))
  end

  private

    def wrap_long_string(text, max_width = 30)
      zero_width_space = "&#8203;"
      # matches from 1 to 30 per se
      regex = /.{1,#{max_width}}/
      (text.length < max_width) ? text : 
                                  text.scan(regex).join(zero_width_space)
    end
end