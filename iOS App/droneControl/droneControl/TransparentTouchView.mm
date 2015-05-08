//
//  TransparentTouchView.m
//  droneControl
//
//  Created by Michael Weingert on 2015-05-07.
//  Copyright (c) 2015 bdw. All rights reserved.
//

#import "TransparentTouchView.h"
#import "CoordinatePointTuple.h"
#import "AerialViewController.h"
#import "DJIDroneHelper.h"

@implementation TransparentTouchView
{
    NSArray * _coordinatePointTuples;
    DJIDroneHelper *_droneHelper;
}

CoordinatePointTuple * createTuple(float x, float y, float xzRatio, float yzRatio)
{
  CoordinatePointTuple * dummy = [[CoordinatePointTuple alloc] init];
  dummy.xPixelRatio = x / (2192 * 2.0);
  dummy.yPixelRatio = y / (1233 * 2.0);
  dummy.xzRatio = xzRatio;
  dummy.yzRatio = yzRatio;
  return dummy;
}

float distanceToTuple(CoordinatePointTuple * currTuple, float xRatio, float yRatio)
{
  float xDist = currTuple.xPixelRatio - xRatio;
  float yDist = currTuple.yPixelRatio - yRatio;
  
  return sqrt(powf(xDist, 2) + powf(yDist, 2));
}

-(int) findIndexOfNearestTuple: (float)xRatio withYRatio:(float) yRatio
{
  float nearestDistance = 1000000;
  int nearestIndex = 0;
  for (int i = 0; i < _coordinatePointTuples.count; i++)
  {
    float currDistance = distanceToTuple(_coordinatePointTuples[i], xRatio, yRatio);
    if (currDistance < nearestDistance)
    {
      nearestIndex = i;
      nearestDistance = currDistance;
    }
  }
  
  return nearestIndex;
}

-(void) viewDidLoad
{
  NSLog(@"view did load");
  
  _droneHelper = [DJIDroneHelper sharedHelper];
  
  _coordinatePointTuples = [NSArray arrayWithObjects:
                            //First row
                            createTuple(478.2323,	300.7952,	-0.55, -1),
                            createTuple(478.2323,	300.7952,	-0.55, -1),
                            createTuple(573.6903,	268.9758,	-0.55, -0.916666667),
                            createTuple(677.1032,	237.1565,	-0.55, -0.833333333),
                            createTuple(796.4258,	213.2919,	-0.55, -0.75),
                            createTuple(919.7258,	181.4726,	-0.55, -0.666666667),
                            createTuple(1043.0258, 157.6081, -0.55,	-0.583333333),
                            createTuple(1186.2129, 133.7435, -0.55,	-0.5),
                            createTuple(1337.3548, 113.8565, -0.55, -0.416666667),
                            createTuple(1492.4742, 93.9694,	-0.55, -0.333333333),
                            createTuple(1655.5484, 78.0597,	-0.55, -0.25),
                            createTuple(1826.5774, 62.15, -0.55, -0.166666667),
                            createTuple(1997.6065, 58.1726, -0.55, -0.083333333),
                            createTuple(2180.5677, 54.1952, -0.55, 0),
                            createTuple(2355.5742, 54.1952, -0.55, 0.083333333),
                            createTuple(2534.5581, 54.1952, -0.55, 0.166666667),
                            createTuple(2709.5645, 66.1274, -0.55, 0.25),
                            createTuple(2876.6161, 78.0597, -0.55, 0.333333333),
                            createTuple(3047.6452, 93.9694, -0.55, 0.416666667),
                            createTuple(3198.7871, 117.8339, -0.55, 0.5),
                            createTuple(3337.9968, 137.721, -0.55, 0.583333333),
                            createTuple(3477.2065, 161.5855, -0.55, 0.666666667),
                            createTuple(3604.4839, 185.45, -0.55,	0.75),
                            createTuple(3727.7839, 209.3145, -0.55, 0.833333333),
                            createTuple(3831.1968, 241.1339, -0.55, 0.916666667),
                            createTuple(3934.6097, 264.9984, -0.55, 1),
                            createTuple(4026.0903, 288.8629, -0.55, 1.083333333),
                            createTuple(4117.571, 320.6823, -0.55, 1.166666667),
                            createTuple(4193.1419, 352.5016, -0.55, 1.25),
                            createTuple(4264.7355, 380.3435, -0.55, 1.333333333),
                            createTuple(4332.3516, 392.2758, -0.55, 1.416666667),
                            //Second row
                            createTuple(464.3837, 419.2148,	-0.466666667,	-1),
                            createTuple(559.9478, 399.3056,	-0.466666667,	-0.916666667),
                            createTuple(659.4936, 379.3965,	-0.466666667,	-0.833333333),
                            createTuple(770.985, 355.5054,	-0.466666667,	-0.75),
                            createTuple(894.4219, 323.6508,	-0.466666667,	-0.666666667),
                            createTuple(1025.8224, 303.7416,	-0.466666667,	-0.583333333),
                            createTuple(1161.2048, 283.8324,	-0.466666667,	-0.5),
                            createTuple(1320.4782, 267.9051,	-0.466666667,	-0.416666667),
                            createTuple(1483.7334, 244.0141,	-0.466666667,	-0.333333333),
                            createTuple(1643.0068, 228.0867,	-0.466666667,	-0.25),
                            createTuple(1814.2257,	220.1231,	-0.466666667,	-0.166666667),
                            createTuple(1997.3901,	208.1776,	-0.466666667,	-0.083333333),
                            createTuple(2176.5727,	208.1776,	-0.466666667,	0),
                            createTuple(2363.7189,	208.1776,	-0.466666667,	0.083333333),
                            createTuple(2538.9196,	208.1776,	-0.466666667,	0.166666667),
                            createTuple(2726.0658,	220.1231,	-0.466666667,	0.25),
                            createTuple(2885.3392,	232.0686,	-0.466666667,	0.333333333),
                            createTuple(3056.5581,	247.9959,	-0.466666667,	0.416666667),
                            createTuple(3219.8134,	263.9233,	-0.466666667,	0.5),
                            createTuple(3367.1412,	283.8324,	-0.466666667,	0.583333333),
                            createTuple(3502.5236,	303.7416,	-0.466666667,	0.666666667),
                            createTuple(3629.9423,	327.6326,	-0.466666667,	0.75),
                            createTuple(3753.3792,	351.5236,	-0.466666667,	0.833333333),
                            createTuple(3856.9069,	379.3965,	-0.466666667,	0.916666667),
                            createTuple(3960.4346,	407.2693,	-0.466666667,	1),
                            createTuple(4055.9986,	423.1966,	-0.466666667,	1.083333333),
                            createTuple(4135.6353,	451.0695,	-0.466666667,	1.166666667),
                            createTuple(4223.2357,	466.9968,	-0.466666667,	1.25),
                            createTuple(4290.9269,	494.8697,	-0.466666667,	1.333333333),
                            createTuple(4358.6181,	518.7607,	-0.466666667,	1.416666667),
                            //Third row
                            createTuple(441.399,	560.772,	-0.383333333,	-1),
                            createTuple(533.7736,	540.6906,	-0.383333333,	-0.916666667),
                            createTuple(642.2134,	520.6091,	-0.383333333,	-0.833333333),
                            createTuple(750.6531,	496.5114,	-0.383333333,	-0.75),
                            createTuple(879.1743,	476.43,	-0.383333333,	-0.666666667),
                            createTuple(1011.7117,	456.3485,	-0.383333333,	-0.583333333),
                            createTuple(1156.298,	436.2671,	-0.383333333,	-0.5),
                            createTuple(1296.8681,	424.2182,	-0.383333333,	-0.416666667),
                            createTuple(1461.5358,	404.1368,	-0.383333333,	-0.333333333),
                            createTuple(1630.2199,	392.0879,	-0.383333333,	-0.25),
                            createTuple(1810.9528,	380.0391,	-0.383333333,	-0.166666667),
                            createTuple(1991.6857,	376.0228,	-0.383333333,	-0.083333333),
                            createTuple(2180.4511,	372.0065,	-0.383333333,	0),
                            createTuple(2361.184,	372.0065,	-0.383333333,	0.083333333),
                            createTuple(2545.9332,	376.0228,	-0.383333333,	0.166666667),
                            createTuple(2730.6824,	384.0554,	-0.383333333,	0.25),
                            createTuple(2911.4153,	392.0879,	-0.383333333,	0.333333333),
                            createTuple(3080.0993,	400.1205,	-0.383333333,	0.416666667),
                            createTuple(3232.7182,	424.2182,	-0.383333333,	0.5),
                            createTuple(3381.3208,	440.2834,	-0.383333333,	0.583333333),
                            createTuple(3525.9072,	460.3648,	-0.383333333,	0.666666667),
                            createTuple(3650.4121,	476.43,	-0.383333333,	0.75),
                            createTuple(3778.9332,	504.544,	-0.383333333,	0.833333333),
                            createTuple(3883.3567,	516.5928,	-0.383333333,	0.916666667),
                            createTuple(3983.7638,	540.6906,	-0.383333333,	1),
                            createTuple(4080.1547,	560.772,	-0.383333333,	1.083333333),
                            createTuple(4164.4967,	580.8534,	-0.383333333,	1.166666667),
                            createTuple(4240.8062,	604.9511,	-0.383333333,	1.25),
                            createTuple(4309.0831,	621.0163,	-0.383333333,	1.333333333),
                            createTuple(4381.3762,	641.0977,	-0.383333333,	1.416666667),
                            //Fourth row
                            createTuple(428.5145,	710.4694,	-0.3,	-1),
                            createTuple(519.9952,	682.6274,	-0.3,	-0.916666667),
                            createTuple(615.4532,	674.6726,	-0.3,	-0.833333333),
                            createTuple(738.7532,	650.8081,	-0.3,	-0.75),
                            createTuple(850.121,	634.8984,	-0.3,	-0.666666667),
                            createTuple(985.3532,	618.9887,	-0.3,	-0.583333333),
                            createTuple(1136.4952,	603.079,	-0.3,	-0.5),
                            createTuple(1287.6371,	583.1919,	-0.3,	-0.416666667),
                            createTuple(1446.7339,	575.2371,	-0.3,	-0.333333333),
                            createTuple(1621.7403,	567.2823,	-0.3,	-0.25),
                            createTuple(1796.7468,	559.3274,	-0.3,	-0.166666667),
                            createTuple(1999.5952,	547.3952,	-0.3,	-0.083333333),
                            createTuple(2174.6016,	547.3952,	-0.3,	0),
                            createTuple(2369.4952,	547.3952,	-0.3,	0.083333333),
                            createTuple(2552.4565,	551.3726,	-0.3,	0.166666667),
                            createTuple(2739.3952,	555.35,	-0.3,	0.25),
                            createTuple(2910.4242,	563.3048,	-0.3,	0.333333333),
                            createTuple(3093.3855,	571.2597,	-0.3,	0.416666667),
                            createTuple(3244.5274,	591.1468,	-0.3,	0.5),
                            createTuple(3403.6242,	607.0565,	-0.3,	0.583333333),
                            createTuple(3542.8339,	618.9887,	-0.3,	0.666666667),
                            createTuple(3666.1339,	630.921,	-0.3,	0.75),
                            createTuple(3789.4339,	654.7855,	-0.3,	0.833333333),
                            createTuple(3904.779,	670.6952,	-0.3,	0.916666667),
                            createTuple(4004.2145,	682.6274,	-0.3,	1),
                            createTuple(4095.6952,	702.5145,	-0.3,	1.083333333),
                            createTuple(4175.2435,	722.4016,	-0.3,	1.166666667),
                            createTuple(4258.7694,	738.3113,	-0.3,	1.25),
                            createTuple(4330.3629,	750.2435,	-0.3,	1.333333333),
                            //Fifth row
                            createTuple(412.6048,	845.7016,	-0.216666667,	-1),
                            createTuple(504.0855,	841.7242,	-0.216666667,	-0.916666667),
                            createTuple(611.4758,	825.8145,	-0.216666667,	-0.833333333),
                            createTuple(722.8435,	809.9048,	-0.216666667,	-0.75),
                            createTuple(846.1435,	801.95,	-0.216666667,	-0.666666667),
                            createTuple(977.3984,	786.0403,	-0.216666667,	-0.583333333),
                            createTuple(1124.5629,	774.1081,	-0.216666667,	-0.5),
                            createTuple(1279.6823,	762.1758,	-0.216666667,	-0.416666667),
                            createTuple(1442.7565,	758.1984,	-0.216666667,	-0.333333333),
                            createTuple(1609.8081,	750.2435,	-0.216666667,	-0.25),
                            createTuple(1796.7468,	738.3113,	-0.216666667,	-0.166666667),
                            createTuple(1987.6629,	734.3339,	-0.216666667,	-0.083333333),
                            createTuple(2182.5565,	730.3565,	-0.216666667,	0),
                            createTuple(2369.4952,	730.3565,	-0.216666667,	0.083333333),
                            createTuple(2572.3435,	730.3565,	-0.216666667,	0.166666667),
                            createTuple(2743.3726,	738.3113,	-0.216666667,	0.25),
                            createTuple(2926.3339,	750.2435,	-0.216666667,	0.333333333),
                            createTuple(3093.3855,	754.221,	-0.216666667,	0.416666667),
                            createTuple(3256.4597,	762.1758,	-0.216666667,	0.5),
                            createTuple(3415.5565,	770.1306,	-0.216666667,	0.583333333),
                            createTuple(3554.7661,	786.0403,	-0.216666667,	0.666666667),
                            createTuple(3682.0435,	793.9952,	-0.216666667,	0.75),
                            createTuple(3813.2984,	813.8823,	-0.216666667,	0.833333333),
                            createTuple(3912.7339,	821.8371,	-0.216666667,	0.916666667),
                            createTuple(4020.1242,	833.7694,	-0.216666667,	1),
                            createTuple(4103.65,	841.7242,	-0.216666667,	1.083333333),
                            createTuple(4195.1306,	861.6113,	-0.216666667,	1.166666667),
                            createTuple(4266.7242,	869.5661,	-0.216666667,	1.25),
                            createTuple(4350.25,	889.4532,	-0.216666667,	1.333333333),
                            //Sixth row
                            createTuple(400.6726,	996.8435,	-0.133333333,	-1),
                            createTuple(496.1306,	988.8887,	-0.133333333,	-0.916666667),
                            createTuple(595.5661,	976.9565,	-0.133333333,	-0.833333333),
                            createTuple(710.9113,	969.0016,	-0.133333333,	-0.75),
                            createTuple(838.1887,	965.0242,	-0.133333333,	-0.666666667),
                            createTuple(969.4435,	953.0919,	-0.133333333,	-0.583333333),
                            createTuple(1116.6081,	945.1371,	-0.133333333,	-0.5),
                            createTuple(1267.75,	937.1823,	-0.133333333,	-0.416666667),
                            createTuple(1430.8242,	933.2048,	-0.133333333,	-0.333333333),
                            createTuple(1613.7855,	925.25,	-0.133333333,	-0.25),
                            createTuple(1788.7919,	925.25,	-0.133333333,	-0.166666667),
                            createTuple(1983.6855,	925.25,	-0.133333333,	-0.083333333),
                            createTuple(2174.6016,	921.2726,	-0.133333333,	0),
                            createTuple(2373.4726,	921.2726,	-0.133333333,	0.083333333),
                            createTuple(2564.3887,	921.2726,	-0.133333333,	0.166666667),
                            createTuple(2755.3048,	921.2726,	-0.133333333,	0.25),
                            createTuple(2934.2887,	929.2274,	-0.133333333,	0.333333333),
                            createTuple(3109.2952,	933.2048,	-0.133333333,	0.416666667),
                            createTuple(3264.4145,	933.2048,	-0.133333333,	0.5),
                            createTuple(3423.5113,	945.1371,	-0.133333333,	0.583333333),
                            createTuple(3562.721,	953.0919,	-0.133333333,	0.666666667),
                            createTuple(3697.9532,	961.0468,	-0.133333333,	0.75),
                            createTuple(3809.321,	965.0242,	-0.133333333,	0.833333333),
                            createTuple(3924.6661,	976.9565,	-0.133333333,	0.916666667),
                            createTuple(4028.079,	980.9339,	-0.133333333,	1),
                            createTuple(4119.5597,	988.8887,	-0.133333333,	1.083333333),
                            createTuple(4203.0855,	992.8661,	-0.133333333,	1.166666667),
                            createTuple(4278.6565,	1012.7532,	-0.133333333,	1.25),
                            createTuple(4346.2726,	1012.7532,	-0.133333333,	1.333333333),
                            //Seventh row
                            createTuple(402.6613,	1147.9855,	-0.05,	-1),
                            createTuple(486.1871,	1144.0081,	-0.05,	-0.916666667),
                            createTuple(593.5774,	1140.0306,	-0.05,	-0.833333333),
                            createTuple(704.9452,	1136.0532,	-0.05,	-0.75),
                            createTuple(832.2226,	1136.0532,	-0.05,	-0.666666667),
                            createTuple(967.4548,	1124.121,	-0.05,	-0.583333333),
                            createTuple(1110.6419,	1128.0984,	-0.05,	-0.5),
                            createTuple(1265.7613,	1120.1435,	-0.05,	-0.416666667),
                            createTuple(1432.8129,	1120.1435,	-0.05,	-0.333333333),
                            createTuple(1607.8194,	1116.1661,	-0.05,	-0.25),
                            createTuple(1794.7581,	1116.1661,	-0.05,	-0.166666667),
                            createTuple(1981.6968,	1112.1887,	-0.05,	-0.083333333),
                            createTuple(2176.5903,	1116.1661,	-0.05,	0),
                            createTuple(2375.4613,	1116.1661,	-0.05,	0.083333333),
                            createTuple(2566.3774,	1116.1661,	-0.05,	0.166666667),
                            createTuple(2749.3387,	1120.1435,	-0.05,	0.25),
                            createTuple(2944.2323,	1116.1661,	-0.05,	0.333333333),
                            createTuple(3107.3065,	1116.1661,	-0.05,	0.416666667),
                            createTuple(3270.3806,	1120.1435,	-0.05,	0.5),
                            createTuple(3425.5,	1120.1435,	-0.05,	0.583333333),
                            createTuple(3564.7097,	1124.121,	-0.05,	0.666666667),
                            createTuple(3695.9645,	1124.121,	-0.05,	0.75),
                            createTuple(3823.2419,	1132.0758,	-0.05,	0.833333333),
                            createTuple(3930.6323,	1132.0758,	-0.05,	0.916666667),
                            createTuple(4030.0677,	1136.0532,	-0.05,	1),
                            createTuple(4121.5484,	1140.0306,	-0.05,	1.083333333),
                            createTuple(4205.0742,	1140.0306,	-0.05,	1.166666667),
                            createTuple(4280.6452,	1144.0081,	-0.05,	1.25),
                            createTuple(4352.2387,	1151.9629,	-0.05,	1.333333333),
                            //Eighth row
                            createTuple(402.6613,	1291.1726,	0.033333333,	-1),
                            createTuple(494.1419,	1291.1726,	0.033333333,	-0.916666667),
                            createTuple(597.5548,	1295.15,	0.033333333,	-0.833333333),
                            createTuple(708.9226,	1299.1274,	0.033333333,	-0.75),
                            createTuple(836.2,	1299.1274,	0.033333333,	-0.666666667),
                            createTuple(971.4323,	1303.1048,	0.033333333,	-0.583333333),
                            createTuple(1114.6194,	1307.0823,	0.033333333,	-0.5),
                            createTuple(1269.7387,	1303.1048,	0.033333333,	-0.416666667),
                            createTuple(1432.8129,	1303.1048,	0.033333333,	-0.333333333),
                            createTuple(1615.7742,	1307.0823,	0.033333333,	-0.25),
                            createTuple(1794.7581,	1307.0823,	0.033333333,	-0.166666667),
                            createTuple(1985.6742,	1307.0823,	0.033333333,	-0.083333333),
                            createTuple(2176.5903,	1307.0823,	0.033333333,	0),
                            createTuple(2375.4613,	1307.0823,	0.033333333,	0.083333333),
                            createTuple(2566.3774,	1307.0823,	0.033333333,	0.166666667),
                            createTuple(2753.3161,	1307.0823,	0.033333333,	0.25),
                            createTuple(2936.2774,	1303.1048,	0.033333333,	0.333333333),
                            createTuple(3111.2839,	1303.1048,	0.033333333,	0.416666667),
                            createTuple(3270.3806,	1303.1048,	0.033333333,	0.5),
                            createTuple(3425.5,	1299.1274,	0.033333333,	0.583333333),
                            createTuple(3564.7097,	1299.1274,	0.033333333,	0.666666667),
                            createTuple(3699.9419,	1295.15,	0.033333333,	0.75),
                            createTuple(3819.2645,	1295.15,	0.033333333,	0.833333333),
                            createTuple(3930.6323,	1291.1726,	0.033333333,	0.916666667),
                            createTuple(4030.0677,	1287.1952,	0.033333333,	1),
                            createTuple(4121.5484,	1287.1952,	0.033333333,	1.083333333),
                            createTuple(4201.0968,	1283.2177,	0.033333333,	1.166666667),
                            createTuple(4280.6452,	1283.2177,	0.033333333,	1.25),
                            createTuple(4356.2161,	1283.2177,	0.033333333,	1.333333333),
                            //Ninth row
                            createTuple(406.6387,	1442.3145,	0.116666667,	-1),
                            createTuple(498.1194,	1454.2468,	0.116666667,	-0.916666667),
                            createTuple(597.5548,	1458.2242,	0.116666667,	-0.833333333),
                            createTuple(708.9226,	1458.2242,	0.116666667,	-0.75),
                            createTuple(840.1774,	1470.1565,	0.116666667,	-0.666666667),
                            createTuple(975.4097,	1478.1113,	0.116666667,	-0.583333333),
                            createTuple(1118.5968,	1482.0887,	0.116666667,	-0.5),
                            createTuple(1269.7387,	1490.0435,	0.116666667,	-0.416666667),
                            createTuple(1440.7677,	1494.021,	0.116666667,	-0.333333333),
                            createTuple(1615.7742,	1494.021,	0.116666667,	-0.25),
                            createTuple(1802.7129,	1501.9758,	0.116666667,	-0.166666667),
                            createTuple(1985.6742,	1501.9758,	0.116666667,	-0.083333333),
                            createTuple(2180.5677,	1501.9758,	0.116666667,	0),
                            createTuple(2375.4613,	1497.9984,	0.116666667,	0.083333333),
                            createTuple(2562.4,	1497.9984,	0.116666667,	0.166666667),
                            createTuple(2749.3387,	1494.021,	0.116666667,	0.25),
                            createTuple(2936.2774,	1490.0435,	0.116666667,	0.333333333),
                            createTuple(3107.3065,	1486.0661,	0.116666667,	0.416666667),
                            createTuple(3270.3806,	1486.0661,	0.116666667,	0.5),
                            createTuple(3417.5452,	1478.1113,	0.116666667,	0.583333333),
                            createTuple(3552.7774,	1466.179,	0.116666667,	0.666666667),
                            createTuple(3691.9871,	1466.179,	0.116666667,	0.75),
                            createTuple(3815.2871,	1462.2016,	0.116666667,	0.833333333),
                            createTuple(3930.6323,	1446.2919,	0.116666667,	0.916666667),
                            createTuple(4022.1129,	1446.2919,	0.116666667,	1),
                            createTuple(4113.5935,	1438.3371,	0.116666667,	1.083333333),
                            createTuple(4197.1194,	1430.3823,	0.116666667,	1.166666667),
                            createTuple(4276.6677,	1430.3823,	0.116666667,	1.25),
                            createTuple(4352.2387,	1422.4274,	0.116666667,	1.333333333),
                            //Tenth row
                            createTuple(412.6048,	1593.4565,	0.2,	-1),
                            createTuple(516.0177,	1605.3887,	0.2,	-0.916666667),
                            createTuple(611.4758,	1617.321,	0.2,	-0.833333333),
                            createTuple(722.8435,	1625.2758,	0.2,	-0.75),
                            createTuple(850.121,	1641.1855,	0.2,	-0.666666667),
                            createTuple(989.3306,	1649.1403,	0.2,	-0.583333333),
                            createTuple(1120.5855,	1657.0952,	0.2,	-0.5),
                            createTuple(1283.6597,	1669.0274,	0.2,	-0.416666667),
                            createTuple(1446.7339,	1673.0048,	0.2,	-0.333333333),
                            createTuple(1617.7629,	1680.9597,	0.2,	-0.25),
                            createTuple(1800.7242,	1692.8919,	0.2,	-0.166666667),
                            createTuple(1999.5952,	1688.9145,	0.2,	-0.083333333),
                            createTuple(2174.6016,	1692.8919,	0.2,	0),
                            createTuple(2377.45,	1688.9145,	0.2,	0.083333333),
                            createTuple(2560.4113,	1688.9145,	0.2,	0.166666667),
                            createTuple(2755.3048,	1684.9371,	0.2,	0.25),
                            createTuple(2926.3339,	1676.9823,	0.2,	0.333333333),
                            createTuple(3101.3403,	1673.0048,	0.2,	0.416666667),
                            createTuple(3260.4371,	1661.0726,	0.2,	0.5),
                            createTuple(3411.579,	1653.1177,	0.2,	0.583333333),
                            createTuple(3558.7435,	1637.2081,	0.2,	0.666666667),
                            createTuple(3686.021,	1629.2532,	0.2,	0.75),
                            createTuple(3801.3661,	1613.3435,	0.2,	0.833333333),
                            createTuple(3904.779,	1609.3661,	0.2,	0.916666667),
                            createTuple(4012.1694,	1589.479,	0.2,	1),
                            createTuple(4103.65,	1581.5242,	0.2,	1.083333333),
                            createTuple(4191.1532,	1573.5694,	0.2,	1.166666667),
                            createTuple(4274.679,	1561.6371,	0.2,	1.25),
                            createTuple(4346.2726,	1553.6823,	0.2,	1.333333333),
                            //Eleventh row
                            createTuple(428.5145,	1736.6435,	0.283333333,	-1),
                            createTuple(527.95,	1748.5758,	0.283333333,	-0.916666667),
                            createTuple(631.3629,	1768.4629,	0.283333333,	-0.833333333),
                            createTuple(742.7306,	1780.3952,	0.283333333,	-0.75),
                            createTuple(866.0306,	1804.2597,	0.283333333,	-0.666666667),
                            createTuple(997.2855,	1816.1919,	0.283333333,	-0.583333333),
                            createTuple(1144.45,	1828.1242,	0.283333333,	-0.5),
                            createTuple(1295.5919,	1836.079,	0.283333333,	-0.416666667),
                            createTuple(1462.6435,	1855.9661,	0.283333333,	-0.333333333),
                            createTuple(1625.7177,	1855.9661,	0.283333333,	-0.25),
                            createTuple(1808.679,	1867.8984,	0.283333333,	-0.166666667),
                            createTuple(1995.6177,	1867.8984,	0.283333333,	-0.083333333),
                            createTuple(2182.5565,	1875.8532,	0.283333333,	0),
                            createTuple(2369.4952,	1871.8758,	0.283333333,	0.083333333),
                            createTuple(2564.3887,	1875.8532,	0.283333333,	0.166666667),
                            createTuple(2747.35,	1867.8984,	0.283333333,	0.25),
                            createTuple(2914.4016,	1855.9661,	0.283333333,	0.333333333),
                            createTuple(3089.4081,	1840.0565,	0.283333333,	0.416666667),
                            createTuple(3248.5048,	1832.1016,	0.283333333,	0.5),
                            createTuple(3403.6242,	1816.1919,	0.283333333,	0.583333333),
                            createTuple(3534.879,	1804.2597,	0.283333333,	0.666666667),
                            createTuple(3666.1339,	1792.3274,	0.283333333,	0.75),
                            createTuple(3789.4339,	1780.3952,	0.283333333,	0.833333333),
                            createTuple(3896.8242,	1756.5306,	0.283333333,	0.916666667),
                            createTuple(4004.2145,	1744.5984,	0.283333333,	1),
                            createTuple(4095.6952,	1724.7113,	0.283333333,	1.083333333),
                            createTuple(4183.1984,	1708.8016,	0.283333333,	1.166666667),
                            createTuple(4258.7694,	1696.8694,	0.283333333,	1.25),
                            createTuple(4330.3629,	1684.9371,	0.283333333,	1.333333333),
                            //Twelfth row
                            createTuple(456.3565,	1887.7855,	0.366666667,	-1),
                            createTuple(543.8597,	1899.7177,	0.366666667,	-0.916666667),
                            createTuple(655.2274,	1915.6274,	0.366666667,	-0.833333333),
                            createTuple(762.6177,	1935.5145,	0.366666667,	-0.75),
                            createTuple(873.9855,	1947.4468,	0.366666667,	-0.666666667),
                            createTuple(1013.1952,	1971.3113,	0.366666667,	-0.583333333),
                            createTuple(1160.3597,	1987.221,	0.366666667,	-0.5),
                            createTuple(1311.5016,	2003.1306,	0.366666667,	-0.416666667),
                            createTuple(1474.5758,	2015.0629,	0.366666667,	-0.333333333),
                            createTuple(1645.6048,	2034.95,	0.366666667,	-0.25),
                            createTuple(1816.6339,	2050.8597,	0.366666667,	-0.166666667),
                            createTuple(1999.5952,	2046.8823,	0.366666667,	-0.083333333),
                            createTuple(2186.5339,	2050.8597,	0.366666667,	0),
                            createTuple(2373.4726,	2046.8823,	0.366666667,	0.083333333),
                            createTuple(2560.4113,	2042.9048,	0.366666667,	0.166666667),
                            createTuple(2739.3952,	2034.95,	0.366666667,	0.25),
                            createTuple(2910.4242,	2023.0177,	0.366666667,	0.333333333),
                            createTuple(3073.4984,	2015.0629,	0.366666667,	0.416666667),
                            createTuple(3236.5726,	2003.1306,	0.366666667,	0.5),
                            createTuple(3375.7823,	1987.221,	0.366666667,	0.583333333),
                            createTuple(3522.9468,	1967.3339,	0.366666667,	0.666666667),
                            createTuple(3650.2242,	1947.4468,	0.366666667,	0.75),
                            createTuple(3773.5242,	1927.5597,	0.366666667,	0.833333333),
                            createTuple(3872.9597,	1911.65,	0.366666667,	0.916666667),
                            createTuple(3988.3048,	1883.8081,	0.366666667,	1),
                            createTuple(4071.8306,	1871.8758,	0.366666667,	1.083333333),
                            createTuple(4155.3565,	1851.9887,	0.366666667,	1.166666667),
                            createTuple(4246.8371,	1836.079,	0.366666667,	1.25),
                            createTuple(4314.4532,	1828.1242,	0.366666667,	1.333333333),
                            //Thirteenth row
                            createTuple(474.2548,	2019.0403,	0.45,	-1),
                            createTuple(569.7129,	2038.9274,	0.45,	-0.916666667),
                            createTuple(669.1484,	2062.7919,	0.45,	-0.833333333),
                            createTuple(776.5387,	2082.679,	0.45,	-0.75),
                            createTuple(903.8161,	2098.5887,	0.45,	-0.666666667),
                            createTuple(1039.0484,	2126.4306,	0.45,	-0.583333333),
                            createTuple(1174.2806,	2146.3177,	0.45,	-0.5),
                            createTuple(1321.4452,	2166.2048,	0.45,	-0.416666667),
                            createTuple(1488.4968,	2182.1145,	0.45,	-0.333333333),
                            createTuple(1655.5484,	2198.0242,	0.45,	-0.25),
                            createTuple(1826.5774,	2205.979,	0.45,	-0.166666667),
                            createTuple(2001.5839,	2209.9565,	0.45,	-0.083333333),
                            createTuple(2180.5677,	2217.9113,	0.45,	0),
                            createTuple(2367.5065,	2213.9339,	0.45,	0.083333333),
                            createTuple(2546.4903,	2209.9565,	0.45,	0.166666667),
                            createTuple(2721.4968,	2202.0016,	0.45,	0.25),
                            createTuple(2892.5258,	2190.0694,	0.45,	0.333333333),
                            createTuple(3059.5774,	2174.1597,	0.45,	0.416666667),
                            createTuple(3218.6742,	2158.25,	0.45,	0.5),
                            createTuple(3357.8839,	2138.3629,	0.45,	0.583333333),
                            createTuple(3501.071,	2118.4758,	0.45,	0.666666667),
                            createTuple(3624.371,	2094.6113,	0.45,	0.75),
                            createTuple(3747.671,	2074.7242,	0.45,	0.833333333),
                            createTuple(3855.0613,	2050.8597,	0.45,	0.916666667),
                            createTuple(3954.4968,	2026.9952,	0.45,	1),
                            createTuple(4049.9548,	1999.1532,	0.45,	1.083333333),
                            createTuple(4133.4806,	1983.2435,	0.45,	1.166666667),
                            createTuple(4213.029,	1955.4016,	0.45,	1.25),
                            createTuple(4284.6226,	1939.4919,	0.45,	1.333333333),
                            createTuple(4348.2613,	1919.6048,	0.45,	1.416666667),
                            //Fourteenth Row
                            createTuple(498.1194,	2154.2726,	0.533333333,	-1),
                            createTuple(593.5774,	2178.1371,	0.533333333,	-0.916666667),
                            createTuple(696.9903,	2202.0016,	0.533333333,	-0.833333333),
                            createTuple(812.3355,	2225.8661,	0.533333333,	-0.75),
                            createTuple(931.6581,	2253.7081,	0.533333333,	-0.666666667),
                            createTuple(1058.9355,	2269.6177,	0.533333333,	-0.583333333),
                            createTuple(1194.1677,	2297.4597,	0.533333333,	-0.5),
                            createTuple(1345.3097,	2313.3694,	0.533333333,	-0.416666667),
                            createTuple(1504.4065,	2333.2565,	0.533333333,	-0.333333333),
                            createTuple(1671.4581,	2341.2113,	0.533333333,	-0.25),
                            createTuple(1834.5323,	2357.121,	0.533333333,	-0.166666667),
                            createTuple(2013.5161,	2369.0532,	0.533333333,	-0.083333333),
                            createTuple(2180.5677,	2365.0758,	0.533333333,	0),
                            createTuple(2363.529,	2373.0306,	0.533333333,	0.083333333),
                            createTuple(2538.5355,	2361.0984,	0.533333333,	0.166666667),
                            createTuple(2709.5645,	2361.0984,	0.533333333,	0.25),
                            createTuple(2884.571,	2341.2113,	0.533333333,	0.333333333),
                            createTuple(3047.6452,	2321.3242,	0.533333333,	0.416666667),
                            createTuple(3198.7871,	2305.4145,	0.533333333,	0.5),
                            createTuple(3341.9742,	2289.5048,	0.533333333,	0.583333333),
                            createTuple(3473.229,	2265.6403,	0.533333333,	0.666666667),
                            createTuple(3608.4613,	2237.7984,	0.533333333,	0.75),
                            createTuple(3723.8065,	2213.9339,	0.533333333,	0.833333333),
                            createTuple(3839.1516,	2186.0919,	0.533333333,	0.916666667),
                            createTuple(3938.5871,	2158.25,	0.533333333,	1),
                            createTuple(4034.0452,	2134.3855,	0.533333333,	1.083333333),
                            createTuple(4113.5935,	2110.521,	0.533333333,	1.166666667),
                            createTuple(4181.2097,	2094.6113,	0.533333333,	1.25),
                            createTuple(4260.7581,	2062.7919,	0.533333333,	1.333333333),
                            createTuple(4336.329,	2038.9274,	0.533333333,	1.416666667),
                            nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  
  if (!_coordinatePointTuples)
  {
    //LOL What am I doing with my life
    [self viewDidLoad];
  }
  NSLog(@"Touches began");

  NSLog(@"Click handler");
  
  UITouch *touch = [[event allTouches] anyObject];
  CGPoint tapLocation = [touch locationInView:touch.view];
  
  //Time to transfer that point into a ratio of height / width
  CGRect frameRect = self.frame;
  float xRatio = tapLocation.x / frameRect.size.width;
  float yRatio = tapLocation.y / frameRect.size.height;
  
  int pointIndex = [self findIndexOfNearestTuple:xRatio withYRatio:yRatio];
  CoordinatePointTuple * nearestIndex = _coordinatePointTuples[pointIndex];
  
  // ASSUME THAT THE DRONE IS FLYING DIRECTLY ABOVE YOU
  AerialViewController * aerialController;
  for (UIView* next = [self superview]; next; next = next.superview)
  {
    UIResponder* nextResponder = [next nextResponder];
    
    if ([nextResponder isKindOfClass:[AerialViewController class]])
    {
      aerialController = nextResponder;
    }
  }
  
  if (aerialController)
  {
    CLLocationCoordinate2D droneGPS = [aerialController getUserLocation].coordinate;
    NSLog(@"DroneALtitude: %f, %f",droneGPS.latitude, droneGPS.longitude);
    // test dronealtitude units
    // yaw: clockwise or counterclick
    // Get height of the drone
    
    // Hard code the altitude here for now
    float droneAltitude = _droneHelper.getDroneHeight;
    NSLog(@"DroneAltitude: %f",droneAltitude);
    //float droneAltitude = 20.0;
    
    // Multiply the height of the drone by the xRatio and yRatio of the point
    float xOffset = droneAltitude * nearestIndex.xzRatio;
    float yOffset = droneAltitude * nearestIndex.yzRatio;
    
    float droneYaw = _droneHelper.getDroneYaw;
    NSLog(@"droneYaw: %f",droneYaw);
    // if wrong multiply by -1 
    float newX = xOffset * cos(droneYaw) - yOffset * sin(droneYaw); // now x is something different than original vector x
    float newY = xOffset * sin(droneYaw) + yOffset * cos(droneYaw);
    
    //Now that we have offsets, we need to rotate according to the yaw of the drone
    
    CLLocationCoordinate2D clickLocation = droneGPS;
    
    //clickLocation.latitude = droneGPS.latitude + (180/3.1415926)*(yOffset/6378137.0);
    clickLocation.latitude = droneGPS.latitude + (180/3.1415926)*(newY/6378137.0);
    //clickLocation.longitude = droneGPS.longitude +  (180/3.1415926)*(xOffset/6378137.0)/cos(droneGPS.latitude);
    clickLocation.longitude = droneGPS.longitude +  (180/3.1415926)*(newX/6378137.0)/cos(droneGPS.latitude);
    [aerialController userDidClickOnSpot:clickLocation];
    
  }
  
  // Get GPS of the drone
  /*CLLocationCoordinate2D droneGPS = _droneHelper.getDroneGPS;
   
   // Get height of the drone
   float droneAltitude = _droneHelper.getDroneHeight;
   
   // Multiply the height of the drone by the xRatio and yRatio of the point
   float xOffset = droneAltitude * nearestIndex.xzRatio;
   float yOffset = droneAltitude * nearestIndex.yzRatio;
   
   CLLocationCoordinate2D clickLocation = droneGPS;
   
   clickLocation.latitude = droneGPS.latitude + (180/3.1415926)*(yOffset/6378137.0);
   clickLocation.longitude = droneGPS.longitude +  (180/3.1415926)*(xOffset/6378137.0)/cos(droneGPS.latitude);*/
  
  // Add marker on map where user clicked.
  // Ugh stupid controller shit.
  
  //AerialViewController * aerialController = [self.view.superview nextResponder];
  //[aerialController userDidClickOnSpot:clickLocation];
  
  
  
  /*UINavigationController * navCont = self.navigationController;
   for (UIViewController * controller in [navCont viewControllers])
   {
   AerialViewController * aerialVC = (AerialViewController *) controller;
   if (aerialVC)
   {
   [aerialVC userDidClickOnSpot:clickLocation];
   }
   }*/
}
/*- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
  NSLog(@"Touches moved");
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  NSLog(@"Touches ended");
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
  NSLog(@"Touches cancelled");
}*/

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
