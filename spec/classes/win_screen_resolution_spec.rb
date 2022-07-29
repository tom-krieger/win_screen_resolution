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

        is_expected.to contain_file('C:\ProgramData\PuppetLabs\win_screen_resolution')
          .with(
            'ensure' => 'directory',
            'owner'  => 'Administrator',
            'group'  => 'Administrator',
          )

        is_expected.to contain_file('C:\ProgramData\PuppetLabs\win_screen_resolution\set_screen_resolution.ps1')
          .with(
            'ensure'  => 'file',
            'owner'   => 'Administrator',
            'group'   => 'Administrator',
          )
          .that_requires('File[C:\ProgramData\PuppetLabs\win_screen_resolution]')

        is_expected.to contain_registry_value('Set logon script')
          .with(
            'path'     => 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\State\Machine\Scripts\Startup\0\0\Script',
            'ensure'   => 'present',
            'data'     => 'C:\ProgramData\PuppetLabs\win_screen_resolution\set_screen_resolution.ps1',
            'type'     => 'string',
          )
          .that_requires('File[C:\ProgramData\PuppetLabs\win_screen_resolution\set_screen_resolution.ps1]')
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

        is_expected.to contain_package('fiddle')
          .with(
            'ensure'   => 'present',
            'provider' => 'puppet_gem',
          )

        is_expected.to contain_file('C:\ProgramData\PuppetLabs\win_screen_resolution')
          .with(
          'ensure' => 'directory',
          'owner'  => 'Administrator',
          'group'  => 'Administrator',
        )

        is_expected.to contain_file('C:\ProgramData\PuppetLabs\win_screen_resolution\set_screen_resolution.ps1')
          .with(
            'ensure'  => 'file',
            'owner'   => 'Administrator',
            'group'   => 'Administrator',
          )
          .that_requires('File[C:\ProgramData\PuppetLabs\win_screen_resolution]')

        is_expected.to contain_registry_value('Set logon script')
          .with(
            'path'     => 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\State\Machine\Scripts\Startup\0\0\Script',
            'ensure'   => 'present',
            'data'     => 'C:\ProgramData\PuppetLabs\win_screen_resolution\set_screen_resolution.ps1',
            'type'     => 'string',
          )
          .that_requires('File[C:\ProgramData\PuppetLabs\win_screen_resolution\set_screen_resolution.ps1]')
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
