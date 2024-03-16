module FlashHelper
  def set_sicklie_sync_flash(sync_result:, patient:)
    error_prefix = "Something went wrong syncing patient '#{patient.first_name} #{patient.last_name}' with Sicklie."
    
    if sync_result.is_a?(String)
      flash[:danger] = "#{error_prefix} #{sync_result}"
    elsif sync_result.is_a?(Array)
      errors = sync_result.map do |result| 
        "#{result[:status_code]}: #{result[:message]}"
      end.join("; ")

      flash[:danger] = "#{error_prefix} #{errors}"
    elsif sync_result.is_a?(Hash) && sync_result[:status_code] == "SUCCESS"
        flash[:success] = "Success! Synced patient '#{patient.first_name} #{patient.last_name}' with Sicklie"
    else
      flash[:danger] = "#{error_prefix} Unknown API error #{sync_result}"
    end
  end
end
