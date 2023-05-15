module UserAccessPointsHelper
  #技師室と談話室はユーザーによって表示SSIDを分ける必要がある
  def which_ssid_id_used?(user)
    if user.id == 4 || user.id == 5 || user.id == 6 || user.id == 8 || user.id == 11 || user.id == 13 || user.id == 16 || user.id == 18 || user.id == 29 || user.id == 35 || user.id == 36 || user.id == 42 || user.id == 45
      return "5g"
    elsif user.id == 12 || user.id == 20 || user.id == 33 || user.id == 38 || user.id == 41 || user.id == 47 || user.id == 49 || user.id == 50 || user.id == 56 || user.id == 107 || user.id == 108 || user.id == 109 || user.id == 110
      return "2.4g"
    elsif user.id == 10 || user.id == 19 || user.id == 22 || user.id == 23 || user.id == 25 || user.id == 26 || user.id == 28 || user.id == 30 || user.id == 31 || user.id == 37 || user.id == 40 || user.id == 48 || user.id == 51 || user.id == 53
      return "lounge"
    elsif user.position_ids.include?(6) || user.position_ids.include?(9)
      return "lounge"
    elsif  user.id == 21
      return "all"
    else
      return false
    end
  end

  def check_wifi_admin(current_user)
    #Wi-Fi管理者、保吉13、新沼42、谷地21、佐藤凌47、大沼遼37
    if current_user.id == 13 || current_user.id == 21 || current_user.id == 42 || current_user.id == 47 || current_user.id == 37
      return true
    else
      return false
    end
  end

end
