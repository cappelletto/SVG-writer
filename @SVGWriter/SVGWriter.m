classdef SVGWriter < handle
    %SVGWRITER MATLAB class to write SVG files
    %   See also: SVGWriter/SVGWriter

    %TODO: docstrings for all methods

    properties % public properties that are set by the constructor but can be edited by the user

        %CANVAS_SIZE is the size in pixels of the canvas.
        %   CANVAS_SIZE = [width, height]
        %   Take care to not confuse the order (x, y) with image size (rows, columns).
        canvas_size(1,2) = [1, 1]

        %RESOLUTION is the resolution of the canvas when displayed
        %   RESOLUTION = cm_per_px
        %   Make sure that all objects that are added to the SVG are specified in pixel coordinates
        %   as the resolution is only applied on .write().
        resolution(1,1) = 1 % cm/px

    end

    properties%(Access=private) % private properties not available to the user

        %SVG_LINES Lines of SVG instructions, typically one line per object
        svg_lines(:,1) string

    end

    methods % constructor etc

        function obj = SVGWriter(canvas_size, resolution)
            %SVGWRITER Construct a SVGWRITER object
            %
            %   Usage:
            %       SVGWriter() constructs an object with default values. These can be changed
            %       before the .write() method is called.
            %       SVGWriter(canvas_size) and SVGWriter(canvas_size, resolution) construct the
            %       object with canvas size and resolution parameters specified.
            %
            %   See also: canvas_size, resolution

            if nargin == 0
                return % use defaults
            end

            % process arguments
            if nargin > 0
                obj.canvas_size = canvas_size;
            end
            if nargin > 1
                obj.resolution = resolution;
            end

        end

    end

    methods(Access=private) % private methods to change private properties

        function add_line_to_svg(this, str)
            str = string(str); % ensure it's a string
            str = str.insertBefore(1, repmat(' ', [1, 4])); % indent with 4 spaces
            this.svg_lines(end+1) = str; % append to data
        end

    end

    methods(Access=public) % add objects to svg block

        function add_comment(this, comment)
            validateattributes(comment, {'char', 'string'}, {'scalartext'});
            commentstr = ['<!--',comment,'-->'];
            this.add_line_to_svg(commentstr);
        end

        function add_description(this, description)
            validateattributes(description, {'char', 'string'}, {'scalartext'});
            descrstr = ['<desc>',description,'</desc>'];
            this.add_line_to_svg(descrstr);
        end
        
        function add_polygon(this, polygon, varargin)
            validateattributes(polygon, {'polyshape'}, {});
            polygonstr = add_polygon_to_svg(polygon, varargin{:});
            this.add_line_to_svg(polygonstr);
        end

        function add_image(this, image, pos)
            if isvector(image) || ndims(image) > 3 || ~any(size(image, 3) == [1, 3])
                error('Expected an image, either grayscale or RGB');
            end
            validateattributes(pos, {'numeric'}, {'numel', 2, 'finite'});
            imagestr = add_image_to_svg(image, pos);
            this.add_line_to_svg(imagestr);
        end

        function add_imagefile(this, filename, pos)
%             if isvector(image) || ndims(image) > 3 || ~any(size(image, 3) == [1, 3])
%                 error('Expected an image, either grayscale or RGB');
%             end
            validateattributes(pos, {'numeric'}, {'numel', 2, 'finite'});
            imagestr = add_imagefile_to_svg(filename, pos);
            this.add_line_to_svg(imagestr);
        end

        function add_line(this, x, y, varargin)
            validateattributes(x, {'numeric'}, {'numel', 2, 'increasing', 'finite'});
            validateattributes(y, {'numeric'}, {'numel', 2, 'increasing', 'finite'});
            linestr = add_line_to_svg(x, y, varargin{:});
            this.add_line_to_svg(linestr);
        end

        function add_rectangle(this, x, y, varargin)
            validateattributes(x, {'numeric'}, {'numel', 2, 'increasing', 'finite'});
            validateattributes(y, {'numeric'}, {'numel', 2, 'increasing', 'finite'});
            outlinestr = add_rectangle_to_svg(x, y, varargin{:});
            this.add_line_to_svg(outlinestr);
        end

        function clear(this, N)
            if nargin < 2
                N = numel(this.svg_lines);
            end
            validateattributes(N, {'numeric'}, {'scalar', 'integer', 'nonnegative'});
            this.svg_lines(end:-1:end-N) = []; % delete
        end

    end

    methods(Access=public) % write all data that was added

        function write(this, filename)
            validateattributes(filename, {'string', 'char'}, {'scalartext'});
            [doc_header, doc_footer] = add_svg_file();
            [svg_header, svg_footer] = add_svg_canvas(this.canvas_size, this.resolution);
            lines = [doc_header(:);
                       svg_header(:);
                         this.svg_lines(:);
                       svg_footer(:);
                     doc_footer(:)];
            write_svg(filename, lines);
        end

        function write_and_clear(this, varargin)
            this.write(varargin{:});
            this.clear();
        end

    end

end
