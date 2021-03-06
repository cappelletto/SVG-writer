function [str_outline] = add_line_to_svg(x, y, varargin)

% https://www.w3.org/TR/SVG11/shapes.html#RectElement

% parse optional style arguments
style = parse_styles(varargin{:});

% add definition
line = sprintf('x1="%f" y1="%f" x2="%f" y2="%f"', x(1), y(1), x(2), y(2));

% combine style and definition
str_outline = sprintf('<line style="%s" %s/>', style.char, line);

end 
