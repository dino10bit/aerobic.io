require 'spec_helper'

include AvatarHelper

describe AvatarHelper do
  describe '#gravatar_for_member' do
    subject { gravatar_for_member(member, options) }

    let(:member) { double(email: 'justin@pixelbloom.com') }
    let(:options) { {} }

    it do
      should == "<figure class=\"avatar\">"\
                "<img alt=\"4914f38406ec528bebfc1f8248e1cf17\" "\
                "class=\"avatar__image\" src=\"//gravatar.com"\
                "/avatar/4914f38406ec528bebfc1f8248e1cf17.png?s=64\" />"\
                "</figure>"
    end

    describe 'options' do
      describe 'when I pass in extra css classes' do
        let(:options) { { extra_classes: 'velociraptors-are-awesome' } }
        it do
          should == "<figure class=\"avatar velociraptors-are-awesome\">"\
                    "<img alt=\"4914f38406ec528bebfc1f8248e1cf17\" "\
                    "class=\"avatar__image\" src=\"//gravatar.com"\
                    "/avatar/4914f38406ec528bebfc1f8248e1cf17.png?s=64\" />"\
                    "</figure>"
        end
      end

      describe 'when I pass in a large size option' do
        let(:options) { { size: :large } }
        it do should == "<figure class=\"avatar--large\">"\
                       "<img alt=\"4914f38406ec528bebfc1f8248e1cf17\" "\
                       "class=\"avatar__image\" src=\"//gravatar.com"\
                       "/avatar/4914f38406ec528bebfc1f8248e1cf17.png?s=164\""\
                       " /></figure>"
        end
      end

      describe 'when I pass in a small size option' do
        let(:options) { { size: :small } }
        it do should == "<figure class=\"avatar--small\">"\
                       "<img alt=\"4914f38406ec528bebfc1f8248e1cf17\" "\
                       "class=\"avatar__image\" src=\"//gravatar.com"\
                       "/avatar/4914f38406ec528bebfc1f8248e1cf17.png?s=32\""\
                       " /></figure>"
        end
      end
    end
  end
end
