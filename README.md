# SnakeActivityIndicatorView
An alternative activity indicator for iOS, written in Objective-C

![SnakeAnimationTypeRotate](https://cloud.githubusercontent.com/assets/2947953/11813039/0fdb7646-a337-11e5-9d8c-daca4572638a.gif)
![SnakeAnimationTypeScale](https://cloud.githubusercontent.com/assets/2947953/11813041/123fca0e-a337-11e5-80b3-07d13889347d.gif)

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
