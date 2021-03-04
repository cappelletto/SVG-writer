function [style] = parse_styles(varargin)

% parse the optional inputs
parser = inputParser();
parser.KeepUnmatched = true;
parser.CaseSensitive = false;
parser.PartialMatching = true;
parser.addOptional('FillColor', '');
parser.addOptional('FillAlpha', 1);
parser.addOptional('FontSize', 10);
parser.addOptional('StrokeColor', '');
parser.addOptional('StrokeWidth', 1);
parser.addOptional('StrokeOpacity', 1);
parser.addOptional('StrokeDashArray', [2 1]);

parser.parse(varargin{:}); % adds them to parser.Results

% process options
style = "";
style = addtolist(style, process('fill:%s', 'FillColor', parser));
style = addtolist(style, process('fill-opacity:%g', 'FillAlpha', parser));
style = addtolist(style, process('font-size:%f', 'FontSize', parser));
style = addtolist(style, process('stroke:%s', 'StrokeColor', parser));
style = addtolist(style, process('stroke-width:%f', 'StrokeWidth', parser));
style = addtolist(style, process('stroke-opacity:%f', 'StrokeOpacity', parser));
style = addtolist(style, process('stroke-dasharray:%f,%f', 'StrokeDashArray', parser));

end

function [str] = addtolist(str, new)

if strlength(new) > 0 % something to add
    if str.strlength > 0 % something already in the string
        new = append(';', new); % prepend the separator
    end
    str = append(str, new);
end

end

function [str] = process(fmt, name, parser, useDefaults)

if nargin < 4
    useDefaults = false; % by default, do not use a parameter if it was not parsed
end

if useDefaults || ~any(contains(parser.UsingDefaults, name, 'IgnoreCase', true))
    str = sprintf(fmt, parser.Results.(name));
else
    str = '';
end

end
