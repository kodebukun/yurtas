module UserAccessPointsHelper
  #技師室と談話室はユーザーによって表示SSIDを分ける必要がある
  #def which_ssid_id_used?(user)
  #  if user.id == 4 || user.id == 5 || user.id == 6 || user.id == 8 || user.id == 11 || user.id == 13 || user.id == 16 || user.id == 18 || user.id == 29 || user.id == 35 || user.id == 36 || user.id == 42 || user.id == 45
  #    return "5g"
  #  elsif user.id == 12 || user.id == 20 || user.id == 23 || user.id == 33 || user.id == 38 || user.id == 41 || user.id == 47 || user.id == 49 || user.id == 50 || user.id == 52 || user.id == 56 || user.id == 107 || user.id == 108 || user.id == 109 || user.id == 110
  #    return "2.4g"
  #  elsif user.id == 10 || user.id == 19 || user.id == 22 || user.id == 25 || user.id == 26 || user.id == 28 || user.id == 30 || user.id == 31 || user.id == 37 || user.id == 40 || user.id == 48 || user.id == 51 || user.id == 53
  #    return "lounge"
  #  elsif user.position_ids.include?(6) || user.position_ids.include?(9)
  #    return "lounge"
  #  elsif  user.id == 21
  #    return "all"
  #  else
  #    return false
  #  end
  #end
  def which_ssid_id_used?(user)
    case user.id
    when 4, 5, 6, 8, 11, 13, 16, 18, 29, 35, 36, 42, 45
      "5g"
    when 12, 14, 20, 23, 33, 38, 41, 47, 49, 50, 52, 56, 107, 108, 109, 110
      "2.4g"
    when 10, 19, 22, 25, 26, 28, 30, 31, 37, 40, 48, 51, 53
      "lounge"
    when 21
      "all"
    else
      if user.position_ids.include?(6) || user.position_ids.include?(9)
        "lounge"
      else
        false
      end
    end
  end


  #def check_wifi_admin(current_user)
    #Wi-Fi管理者、保吉13、新沼42、谷地21、佐藤凌47、大沼遼37
  #  if current_user.id == 13 || current_user.id == 21 || current_user.id == 42 || current_user.id == 47 || current_user.id == 37
  #    return true
  #  else
  #    return false
  #  end
  #end
  def check_wifi_admin(current_user)
    #Wi-Fi管理者、保吉13、新沼42、谷地21、佐藤凌47、大沼遼37
    [13, 21, 42, 47, 37].include?(current_user.id)
  end


end
