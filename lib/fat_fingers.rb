class FatFingers
  attr_reader :email

  class << self
    def clean_up_typoed_email(email)
      new(email).clean_up_typoed_email
    end
  end

  def initialize(email)
    @email = email
  end

  # Internal: Check a given string for misspelled TLDs and misspelled domains from popular e-mail providers.
  #
  # Examples
  #
  #   "joe@gmail.cmo".clean_up_typoed_email
  #   # => "joe@gmail.com"
  #
  #   "joe@yaho.com".clean_up_typoed_email
  #   # => "joe@yahoo.com"
  #
  # Returns the cleaned String.
  def clean_up_typoed_email
    email.downcase!

    remove_invalid_characters
    fix_transposed_periods
    remove_period_before_at_sign
    handle_different_country_tlds
    fix_coms_with_appended_letters
    clean_up_funky_coms
    clean_up_funky_nets
    clean_up_funky_orgs
    clean_up_gmail
    clean_up_googlemail
    clean_up_hotmail
    clean_up_yahoo
    clean_up_aol
    clean_up_other_providers
    clean_up_known_coms
    add_a_period_if_they_forgot_it

    email
  end

  private

  def remove_invalid_characters
    email.gsub!(/(\s|\#|\'|\"|\\)*/, "")
    email.gsub!(/(\,|\.\.)/, ".".freeze)
    email.gsub!("@@", "@".freeze)
  end

  def fix_transposed_periods
    email.gsub!(/c\.om$/, ".com".freeze)
    email.gsub!(/n\.et$/, ".net".freeze)
    # can't do "o.gr" => ".org", as ".gr" is a valid TLD
  end

  def remove_period_before_at_sign
    email.gsub!(/\.*@/, "@".freeze)
  end

  def handle_different_country_tlds
    email.gsub!(/\.(o\.uk|couk|co\.um)$/, ".co.uk".freeze)
    email.gsub!(/\.(cojp|co\.lp)$/, ".co.jp".freeze)
  end

  def fix_coms_with_appended_letters
    email.gsub!(/\.com\.$/, ".com".freeze)
    email.gsub!(/\.com[^\.].*$/, ".com".freeze)
    email.gsub!(/\.co[^op]$/, ".com".freeze)
  end

  def clean_up_funky_coms
    email.gsub!(/\.c*(c|ci|coi|l|m|n|o|op|cp|0)*m+o*$/,".com".freeze)
    email.gsub!(/\.(c|v|x)o+(m|n)$/,".com".freeze)
  end

  def clean_up_funky_nets
    email.gsub!(/\.(nte*|n*et*)$/, ".net".freeze)
  end

  def clean_up_funky_orgs
    email.gsub!(/\.o+g*r*g*$/, ".org".freeze) # require the o, to not false-positive .gr e-mails
  end

  def clean_up_googlemail
    email.gsub!(/@(g(o)*)*le(n|m)*(a|i|l)+m*(a|i|k|l)*\./,"@googlemail.".freeze)
  end

  def clean_up_gmail
    email.gsub!(/@g(n|m)*(a|i|l)+m*(a|i|k|l)*\./,"@gmail.".freeze)
  end

  def clean_up_hotmail
    email.gsub!(/@h(o|p)*y*t*o*a*m*t*(a|i|k|l)*\./,"@hotmail.".freeze)
  end

  def clean_up_yahoo
    email.gsub!(/@y*a*h*a*o*\./,'@yahoo.'.freeze)
    email.gsub(/(?!@ya\.)@y*a*h*a*o*\./,'@yahoo.'.freeze)
  end

  def clean_up_aol
    email.gsub!(/@ol\./,"@aol.")
  end

  def clean_up_other_providers
    email.gsub!(/@co*ma*cas*t\.net/,'@comcast.net'.freeze)
    email.gsub!(/@sbcglob(a|l)\.net/, '@sbcglobal.net'.freeze)
    email.gsub!(/@ver*i*z*on\.net/,'@verizon.net'.freeze)
  end

  def clean_up_known_coms
    email.gsub!(/(aol|googlemail|gmail|hotmail|yahoo).co$/, '\1.com'.freeze)
  end

  def add_a_period_if_they_forgot_it
    email.gsub!(/([^\.])(com|org|net)$/, '\1.\2'.freeze)
  end
end
