# frozen_string_literal: true
require 'jwt'

module JsonWebToken
  extend ActiveSupport::Concern

  SECRET_KEY = Rails.application.secret_key_base

  def encode(payload)
    JWT.encode(payload, SECRET_KEY)
  end

  def decode(token)
    JWT.decode(token, SECRET_KEY).first
  rescue JWT::DecodeError, JWT::ExpiredSignature
    nil
  end
end
