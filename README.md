# SnakeActivityIndicatorView
An alternative activity indicator for iOS, written in Objective-C

![snakeactivityindicatorview](https://cloud.githubusercontent.com/assets/2947953/11768910/f657ef70-a1d2-11e5-9538-9242878cc3fa.gif)

#### Adding a view:

```objective-c
SnakeActivityIndicatorView sView = [[SnakeActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
[view addSubView:sView];
```

The activity indicator will fit to the shortest side of the frame but better use equal width/height

#### Start/stop animation:

```objective-c
[snakeView startAnimating];
[snakeView stopAnimating];
```

#### Setting a full rotation duration:

```objective-c
//default is 1 sec
snakeView.fullCircleDuration = 0.5;
```
