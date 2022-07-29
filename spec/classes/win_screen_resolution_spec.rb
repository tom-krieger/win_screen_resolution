# frozen_string_literal: true

require 'spec_helper'

describe 'win_screen_resolution' do
  on_supported_os.each do |os, os_facts|
    context "on #{os} without gem installation" do
      let(:facts) do
        os_facts.merge!(
          'win_screen_resolution' => {
            'width' => 1024,
            'height' => 768,
          },
        )
      end
      let(:params) do
        {
          'width' => 1600,
          'height' => 1200,
          'install_agent_gems' => false,
        }
      end

      it {
        is_expected.to compile

        is_expected.to contain_echo('Set resolution')
          .with(
            'message'  => 'Setting screen resolution to 1600 x 1200',
            'loglevel' => 'info',
            'withpath' => false,
          )

        is_expected.to contain_exec('rename-guest')
          .with(
            'command'   => 'Set-DisplayResolution -Height 1200 -Width 1600 -Force',
            'provider'  => 'powershell',
            'logoutput' => true,
          )
      }
    end

    context "on #{os} with gem installation" do
      let(:facts) do
        os_facts.merge!(
          'win_screen_resolution' => {
            'width' => 1024,
            'height' => 768,
          },
        )
      end
      let(:params) do
        {
          'width' => 1600,
          'height' => 1200,
          'install_agent_gems' => true,
        }
      end

      it {
        is_expected.to compile

        is_expected.to contain_echo('Set resolution')
          .with(
            'message'  => 'Setting screen resolution to 1600 x 1200',
            'loglevel' => 'info',
            'withpath' => false,
          )

        is_expected.to contain_exec('rename-guest')
          .with(
            'command'   => 'Set-DisplayResolution -Height 1200 -Width 1600 -Force',
            'provider'  => 'powershell',
            'logoutput' => true,
          )

        is_expected.to contain_package('fiddle')
          .with(
            'ensure'   => 'present',
            'provider' => 'puppet_gem',
          )
      }
    end

    context "on #{os} with wrong resolution" do
      let(:facts) do
        os_facts.merge!(
          'win_screen_resolution' => {
            'width' => 1024,
            'height' => 768,
          },
        )
      end
      let(:params) do
        {
          'width' => 1601,
          'height' => 1201,
          'install_agent_gems' => false,
        }
      end

      it {
        is_expected.to compile.and_raise_error(%r{Screen resolution.*is invalid.})
      }
    end
  end
end
