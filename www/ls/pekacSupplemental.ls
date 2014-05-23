ig.supplementalCircles =
    prepare : (@parent) ->
        @prepareElements!
        return if ig.ie8
        @prepareCircles!

    prepareElements : ->
        @attendanceGroup = @parent.append \div
            ..attr \class \attendance
            ..append "span"
                ..html "Volební účast"
                ..attr \class \txt
        @attendancePercent = @attendanceGroup.append \span
            ..attr \class \value

    prepareCircles : ->
        @arc = d3.svg.arc!
        @arcDefinition =
            innerRadius: 30
            outerRadius: 40
            startAngle: 0
            endAngle: 2 * Math.PI
        completeArcPath = @arc @arcDefinition

        groups = [@attendanceGroup]
        @supplementalCircles = for group in groups
            processedSvg = group.append \svg
            arcs = new Array 2
            arcs[0] = processedSvg.append \path
                ..attr \transform "translate(40, 40)"
            arcs[1] = processedSvg.append \path
                ..attr \class \actual
                ..attr \transform "translate(40, 40)"
            arcs

    set: (attendance) ->
        @attendancePercent.html "#{Math.round attendance * 100} <span>%</span>"
        return if ig.ie8
        percentages = [attendance]
        for percentage, index in percentages
            @arcDefinition.startAngle = 0
            @arcDefinition.endAngle = percentage * Math.PI * 2
            d1 = @arc @arcDefinition
            @arcDefinition.startAngle = @arcDefinition.endAngle
            @arcDefinition.endAngle = Math.PI * 2
            d2 = @arc @arcDefinition
            @supplementalCircles[index][0]
                ..attr \d d1
            @supplementalCircles[index][1]
                ..attr \d d2


ig.supplementalPaginator =
    init: (barchartArea, @barchartBelt, @pageCount) ->
        @drawElements barchartArea
        @currentPage = 0

    drawElements: (parent) ->
        paginator = parent.append \div
            ..attr \class \paginator
            ..append \div
                ..attr \class \leftArrow
                ..append \div
                ..on \click ~> @setPage @currentPage - 1
            ..append \div
                ..attr \class \rightArrow
                ..append \div
                ..on \click ~> @setPage @currentPage + 1
            ..append \span
                ..append \span
                    ..html "1"
                    ..attr \class \current
                ..append \span
                    ..html "/#{@pageCount}"
        @currentPageElement = paginator.select \span.current

    setPage: (@currentPage) ->
        @currentPage += @pageCount
        @currentPage %= @pageCount
        @currentPageElement.html @currentPage + 1
        @barchartBelt.style \left "#{@currentPage * (-510)}px"
