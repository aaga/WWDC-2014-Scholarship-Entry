(function ($){

    // prevents errors on deleting items
    Backbone.sync = function(method, model, success, error){
        success();
    }  

    var GameData = Backbone.Model.extend({
        defaults: {
            score: 0,
            mode: 3
        }
    });

    var GameOverView = Backbone.View.extend({

        el: $(".container"),

        events: {
        },

        initialize: function(){
            _.bindAll(this, 'render', 'play', 'touchStart');
            $(window).bind("touchstart", this.touchStart);

            this.render();
        },

        render: function(){
            var template = _.template($("#game-over-template").html(), {gameData: this.model});
            this.el.html(template);

            // Center game over
            var centerGameOver = function() {
                $('#game-over-text').css({
                    'font-size': ($(window).height() * 0.1)
                });
                $('#final-score').css({
                    'font-size': ($(window).height() * 0.1)
                }); 
                $('#retry').css({
                    'font-size': ($(window).height() * 0.1)
                });                 
                $('#instructions').css({
                    'font-size': ($(window).height() * 0.05)
                });
                $('#high-score').css({
                    'font-size': ($(window).height() * 0.1)
                });     
                $('.game-over').css({
                    position: 'relative',
                    width: $('#retry').outerWidth(),
                    top: ($(window).height() - $('#game-over-text').outerHeight() - $('#final-score').outerHeight() - $('#retry').outerHeight() - $('#instructions').outerHeight())/2
                });
                $('body').css({
                    'background-color': '#FFCCCC'
                })
            }

            centerGameOver();

            $(window).resize(centerGameOver);
        },

        play: function(){
            var self = this;
            self.model.set({"score": 0});
            $(window).off("resize");
            $(window).unbind("touchstart");
            self.unbind();
            var gameView = new GameView({
                model: self.model
            });
        },

        touchStart: function(e){
            var self = this;
            self.play();      
        }

    });

    var GameView = Backbone.View.extend({

        el: $(".container"),

        events: {
        },

        initialize: function(){
            _.bindAll(this, 'render', 'touchStart');
            $(window).bind("touchstart", this.touchStart);

            this.render();
        },

        render: function(){
            var template = _.template($("#game-template").html(), {gameData: this.model});
            this.el.html(template);

            var self = this;
            self.subTime = 1;
            self.numCircles = Math.floor(Math.random() * 2) + self.model.get('mode');
            var windowWidth = $(window).width();
            var windowHeight = $(window).height();
            var circleSize = Math.floor(0.1 * windowHeight);

            var minX = circleSize;
            var maxX = windowWidth - circleSize;
            var rangeX = maxX-minX;
            var minY = circleSize + circleSize;
            var maxY = windowHeight - circleSize;
            var rangeY = maxY-minY;

            self.paper = new ScaleRaphael("wrap", windowWidth, windowHeight);
            var st = self.paper.set();

            // Organising game elements for window resize
            var organise = function() {
                $('.game').css({
                    'font-size': ($(window).height() * 0.1)
                });
                $('#timer').css({
                    padding: 0,
                    position: 'relative',
                    'background-color': '#FFCCCC',
                    height: $(window).height(),
                    width: $(window).width(),
                    left: -($(window).width())
                });
                $('body').css({
                    'background-color': '#D0FFCC'
                });
                self.paper.changeSize($(window).width(),$(window).height(),true, false);
            }

            organise();

            $(window).resize(organise);

            // Draw circles
            for (var i = 0; i < self.numCircles; i++) {
                var intersection = true;
                while (intersection){
                    intersection = false;
                    var circle = self.paper.circle((Math.floor(Math.random() * rangeX+1) + minX), (Math.floor(Math.random() * rangeY+1) + minY), circleSize);
                    var circleBBox = circle.getBBox();
                    st.forEach(function(setCircle){
                        var setCircleBBox = setCircle.getBBox();
                        if (Raphael.isBBoxIntersect(circleBBox, setCircleBBox)) {intersection = true;};
                    });

                    if (intersection) {
                        circle.remove();
                    }
                    else {
                        st.push(circle);
                    }
                }
            };
            st.attr({fill: "black"});

            // Timer
            $('#timer').animate({
                left: 0
            }, 850, function(){self.gameOver("timeout");});
        },

        touchStart: function(e){
            var self = this;
            var windowWidth = $(window).width();
            if (e.originalEvent.touches[e.originalEvent.touches.length - 1].pageX < windowWidth/2){
                self.paper.remove();
                $('#timer').stop();
                if (self.numCircles == self.model.get('mode')){
                    self.model.set({"score": self.model.get('score')+1});
                    self.render();
                }   
                else {
                    self.gameOver("wrong");
                };
            }
            else {
                self.paper.remove();
                $('#timer').stop();
                if (self.numCircles == self.model.get('mode')+1){
                    self.model.set({"score": self.model.get('score')+1});
                    self.render();
                }   
                else {
                    self.gameOver("wrong");
                };
            };
        },

        gameOver: function(how){
            var self = this;
            self.unbind;
            if (localStorage["dotz.high.score"]) {
                if (localStorage["dotz.high.score"] < self.model.get('score')) {
                    localStorage["dotz.high.score"] = self.model.get('score');
                };
            } else {
                localStorage["dotz.high.score"] = self.model.get('score');
            };
            console.log(localStorage["dotz.high.score"]);
            $(window).unbind("touchstart");
            $(window).off("resize");
            window.clearInterval(self.timerAnimation);
            var gameOverView = new GameOverView({
                model: self.model
            });
        }

    });    

    var MenuView = Backbone.View.extend({

        el: $(".container"),

        events: {
        },

        initialize: function(){
            _.bindAll(this, 'render', 'play', 'touchStart');
            $(window).bind("touchstart", this.touchStart);
            $(document).bind('touchmove', false);

            this.model = new GameData;

            this.render();
        },

        render: function(){
            var template = _.template($("#menu-template").html());
            this.el.html(template);

            // Centering the menu

            var centerMenu = function() {
                $('#play').css({
                    'font-size': ($(window).height() * 0.1)
                });
                $('#instructions').css({
                    'font-size': ($(window).height() * 0.05)
                });
                $('#high-score').css({
                    'font-size': ($(window).height() * 0.1)
                });
                $('.menu').css({
                    position: 'relative',
                    width: $('#instructions').outerWidth(),
                    top: ($(window).height() - $('#play').outerHeight() - $('#instructions').outerHeight())/2,
                });
            }

            centerMenu();
            
            $(window).resize(centerMenu);
        },

        play: function(){
            var self = this;
            $(window).off("resize");
            $(window).unbind("touchstart");
            var gameView = new GameView({
                model: self.model
            });
            self.unbind();
        },

        touchStart: function(e){
            var self = this;
            self.play();
        }

    });

    var menuView = new MenuView();


})(jQuery);