# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2020 Rother OSS GmbH, https://otobo.de/
# --
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later version.
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.
# --

use strict;
use warnings;
use utf8;

# Set up the test driver $Self when we are running as a standalone script.
use if __PACKAGE__ ne 'Kernel::System::UnitTest::Driver', 'Kernel::System::UnitTest::RegisterDriver';

use vars (qw($Self));

# get layout object
my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

# rich text tests
my @Tests = (
    {
        Name => '_RichTextReplaceLinkOfInlineContent() - generated by outlook',
        String =>
            '<img alt="" src="/otobo-cvs/otobo-cvs/bin/cgi-bin/index.pl?Action=PictureUpload&amp;FormID=1255961382.1012148.29113074&amp;ContentID=&lt;734083011@19102009-1795&gt;" />',
        Result => '<img alt="" src="cid:&lt;734083011@19102009-1795&gt;" />',
    },
    {
        Name => '_RichTextReplaceLinkOfInlineContent() - generated itself',
        String =>
            '<img width="343" height="563" alt="" src="/otobo-cvs/otobo-cvs/bin/cgi-bin/index.pl?Action=PictureUpload&amp;FormID=1255961382.1012148.29113074&amp;ContentID=inline244217.547683276.1255961382.1012148.29113074@vo7.vo.otrs.com" />',
        Result =>
            '<img width="343" height="563" alt="" src="cid:inline244217.547683276.1255961382.1012148.29113074@vo7.vo.otrs.com" />',
    },
    {
        Name => '_RichTextReplaceLinkOfInlineContent() - generated itself, with newline',
        String =>
            "<img width=\"343\" height=\"563\" alt=\"\"\nsrc=\"/otobo-cvs/otobo-cvs/bin/cgi-bin/index.pl?Action=PictureUpload&amp;FormID=1255961382.1012148.29113074&amp;ContentID=inline244217.547683276.1255961382.1012148.29113074\@vo7.vo.otrs.com\" />",
        Result =>
            "<img width=\"343\" height=\"563\" alt=\"\"\nsrc=\"cid:inline244217.547683276.1255961382.1012148.29113074\@vo7.vo.otrs.com\" />",
    },
    {
        Name =>
            '_RichTextReplaceLinkOfInlineContent() - generated itself, with internal and external image',
        String =>
            '<img width="140" vspace="10" hspace="1" height="38" border="0" alt="AltText" src="http://www.otrs.com/fileadmin/templates/skins/skin_otobo/css/images/logo.gif" /> This text should be displayed <img width="400" height="81" border="0" alt="Description: cid:image001.jpg@01CC3AFE.F81F0B30" src="/otobo/index.pl?Action=PictureUpload&amp;FormID=1311080525.12118416.3676164&amp;ContentID=image001.jpg@01CC4216.1E22E9A0" id="Picture_x0020_1" />',
        Result =>
            '<img width="140" vspace="10" hspace="1" height="38" border="0" alt="AltText" src="http://www.otrs.com/fileadmin/templates/skins/skin_otobo/css/images/logo.gif" /> This text should be displayed <img width="400" height="81" border="0" alt="Description: cid:image001.jpg@01CC3AFE.F81F0B30" src="cid:image001.jpg@01CC4216.1E22E9A0" id="Picture_x0020_1" />',
    },
    {
        Name =>
            '_RichTextReplaceLinkOfInlineContent() - generated itself, with internal and external image, no space before />',
        String =>
            '<img width="140" vspace="10" hspace="1" height="38" border="0" alt="AltText" src="http://www.otrs.com/fileadmin/templates/skins/skin_otobo/css/images/logo.gif" /> This text should be displayed <img width="400" height="81" border="0" alt="Description: cid:image001.jpg@01CC3AFE.F81F0B30" src="/otobo/index.pl?Action=PictureUpload&amp;FormID=1311080525.12118416.3676164&amp;ContentID=image001.jpg@01CC4216.1E22E9A0" id="Picture_x0020_1"/>',
        Result =>
            '<img width="140" vspace="10" hspace="1" height="38" border="0" alt="AltText" src="http://www.otrs.com/fileadmin/templates/skins/skin_otobo/css/images/logo.gif" /> This text should be displayed <img width="400" height="81" border="0" alt="Description: cid:image001.jpg@01CC3AFE.F81F0B30" src="cid:image001.jpg@01CC4216.1E22E9A0" id="Picture_x0020_1"/>',
    },
    {
        Name =>
            '_RichTextReplaceLinkOfInlineContent() - generated itself, ContentID in src, > just after src',
        String =>
            '<img src="/app/index.pl?Action=PictureUpload&amp;FormID=1111111111.2222222.33333333&amp;ContentID=test1@test"></img>',
        Result =>
            '<img src="cid:test1@test"></img>',
    },
    {
        Name =>
            '_RichTextReplaceLinkOfInlineContent() - generated itself, ContentID in other attribute than src, ContentID in src also',
        String =>
            '<img src="/app/index.pl?Action=PictureUpload&amp;FormID=1111111111.2222222.33333333&amp;ContentID=test1@test" other_attribute_with_different_contentid="ContentID=test2@test" style="color: #000;">',
        Result =>
            '<img src="cid:test1@test" other_attribute_with_different_contentid="ContentID=test2@test" style="color: #000;">',
    },
    {
        Name =>
            '_RichTextReplaceLinkOfInlineContent() - generated itself, ContentID in other attribute than src, no ContentID in src',
        String =>
            '<img src="/app/index.pl?Action=PictureUpload&amp;FormID=1111111111.2222222.33333333" other_attribute_with_different_contentid="ContentID=test2@test" style="color: #000;">',
        Result =>
            '<img src="/app/index.pl?Action=PictureUpload&amp;FormID=1111111111.2222222.33333333" other_attribute_with_different_contentid="ContentID=test2@test" style="color: #000;">',
    },
);

for my $Test (@Tests) {
    my $HTML = $LayoutObject->_RichTextReplaceLinkOfInlineContent(
        String => \$Test->{String},
    );
    $Self->Is(
        ${$HTML} || '',
        $Test->{Result},
        $Test->{Name},
    );
}

1;
