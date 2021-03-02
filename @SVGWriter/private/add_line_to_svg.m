function [str_outline] = add_line_to_svg(x, y, varargin)

% https://www.w3.org/TR/SVG11/shapes.html#RectElement

% parse optional style arguments
style = parse_styles(varargin{:});

% add definition
line = sprintf('x1="%d" y1="%d" x2="%d" y2="%d"', x(1)-1, y(1)-1, x(2)-1, y(2)-1);

% combine style and definition
str_outline = sprintf('<line style="%s" %s/>', style.char, line);

end 
