class Inquiry < ActiveRecord::Base
  include Gigmit::Concern::Negotiation
  include Gigmit::Concern::Riders

  after_save :save_technical_rider, :save_catering_rider

  def save_technical_rider
    current_profile = self.artist
    technical_rider = current_profile.technical_rider

    if technical_rider.blank? && self.technical_rider.present?
      current_profile.build_technical_rider(user_id: self.user.id).save!
      MediaItemWorker.perform_async(self.technical_rider.id, technical_rider.id)
    end
  end

  def save_catering_rider
    current_profile = self.artist
    catering_rider = current_profile.catering_rider

    if catering_rider.blank? && self.catering_rider.present?
      current_profile.build_catering_rider(user_id: self.user.id).save!
      MediaItemWorker.perform_async(self.catering_rider.id, catering_rider.id)
    end
  end
end
