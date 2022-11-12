include UNI

$cmdEndChar="0x0A"
$timeOut=1000
$timerPeriod=1000
$rate=["0.4","1","5","10"]
$polarity=["Normal","Inverted"]

def isNumber(ch)
	if (ch >= ?0.ord && ch <= ?9.ord)
		return true
	end
	return false
end


class Detector < DetectorSubDeviceWrapper
	def initialize
		super
	end
	
	def Init #Put in the word decument file
		SetRate($rate[1].to_f)
		SetRange(10.0)
		SetXUnits("min", "Time", false, 1.0)
	end
end

class ChoiceList
	# Constructor.
	def initialize(uiitemcollection, listName, listTitle, initValue, values, validationFunction)

		# save necessary values
		@m_uiItemCollection = uiitemcollection
		@m_listName = listName
		@m_values = values

		# create UI choice list
		@m_uiItemCollection.AddChoiceList(@m_listName, listTitle, @m_values[initValue], validationFunction)

		# fill choice items
		@m_values.each { |value| @m_uiItemCollection.AddChoiceListItem(@m_listName, value) }
	end

	# Get current index
	def getCurIndex
		return @m_values.index(@m_uiItemCollection.GetString(@m_listName))
	end

	# Get current value
	def getCurValue
		return @m_uiItemCollection.GetString(@m_listName)
	end

	# Set current index
	def setCurIndex(index, method = nil)
		#TraceLine('>>> ChoiceList.setCurIndex index=' + index.to_s)
		if (method == nil)
			method = @m_uiItemCollection
		end
		method.SetString(@m_listName, @m_values[index])
		#TraceLine('    ChoiceList.setCurIndex end')
	end

	# Set current value
	def setCurValue(value, method = nil)
		#TraceLine('>>> ChoiceList.setCurValue value=' + value)
		if (method == nil)
			method = @m_uiItemCollection
		end
		method.SetString(@m_listName, value)
		#TraceLine('    ChoiceList.setCurValue end')
	end
end

class Device < DeviceWrapper
	def initialize
		super
	end
	
	def InitConfiguration
		
		Configuration().AddString("DetectorName", "Detector Name", "My RI Detector", "VerifyDetectorName")
		Configuration().AddString("DetectorInfo", "Detector Info", "", "")
		Configuration().AddCheckBox("SetTempFromMethod", "Set Temperature From Method", true)
		Configuration().AddCheckBox("SwitchTempOffShutDown", "Set Temperature Off On Shutdown", true)
		
	end
	
	def Init
				
		@peak=[0.0322, 0.0381, 0.0417, 0.0453, 0.0405, 0.0513, 0.0668, 0.0739, 0.0799, 0.0966, 0.1097, 0.1311, 0.155, 0.1824, 0.2122, 0.2468, 0.2885, 0.335, 0.3839, 0.4387, 0.5019, 0.5782, 0.6676, 0.7665, 0.8833, 1.0133, 1.1528, 1.3232, 1.4973, 1.6987, 1.9169, 2.1684, 2.4474, 2.7633, 3.1102, 3.4928, 3.922, 4.3917, 4.89, 5.4467, 6.0582, 6.7174, 7.4291, 8.2242, 9.0742, 9.9683, 10.9506, 12.0008, 13.1273, 14.3325, 15.6152, 16.979, 18.4238, 19.9425, 21.5268, 23.216, 24.9791, 26.8304, 28.7616, 30.7465, 32.8231, 34.97, 37.1635, 39.413, 41.7292, 44.0836, 46.4725, 48.8985, 51.3363, 53.7956, 56.2537, 58.6975, 61.1341, 63.5409, 65.9192, 68.2342, 70.4873, 72.6676, 74.7657, 76.7553, 78.6376, 80.4198, 82.0827, 83.5824, 84.9521, 86.1549, 87.2087, 88.0897, 88.7966, 89.339, 89.6919, 89.8683, 89.8695, 89.6704, 89.2961, 88.7489, 88.0277, 87.136, 86.0739, 84.8377, 83.4644, 81.9385, 80.2708, 78.4934, 76.5848, 74.5797, 72.4959, 70.3061, 68.0399, 65.7201, 63.3562, 60.9398, 58.5139, 56.0594, 53.6013, 51.1515, 48.703, 46.2747, 43.8869, 41.5456, 39.2342, 36.9751, 34.7817, 32.6407, 30.5879, 28.5995, 26.6826, 24.8528, 23.0885, 21.4076, 19.7983, 18.2915, 16.8622, 15.5091, 14.2288, 13.0284, 11.9221, 10.879, 9.8991, 8.9967, 8.1539, 7.3814, 6.6721, 6.0177, 5.4181, 4.8566, 4.3571, 3.8874, 3.463, 3.0935, 2.7394, 2.4247, 2.1493, 1.9121, 1.682, 1.4865, 1.3137, 1.1516, 0.9918, 0.8678, 0.7606, 0.6688, 0.5746, 0.4959, 0.4327, 0.3695, 0.3219, 0.2849, 0.242, 0.2098, 0.1848, 0.1562, 0.1299, 0.1144, 0.1013, 0.0882, 0.0858, 0.0715, 0.0608, 0.0417, 0.0274, 0.0298, 0.031, 0.031, 0.0405, 0.031]
	
		@complete_chromatogram=[-0.006, -0.006, -0.006, -0.006, -0.006, -0.006, -0.006, -0.006, -0.006, -0.006, -0.006, -0.006, -0.006, -0.006, -0.006, -0.0012, 0, 0, -0.0095, -0.0024, 0.0095, 0.0024, 0.0072, -0.0024, -0.0072, -0.0048, -0.0072, -0.0012, -0.0036, 0.0048, 0.0036, -0.0048, 0.0036, 0, -0.0048, -0.0072, 0.0024, 0.0036, -0.0048, 0.0012, 0, 0.0095, 0.0036, -0.0048, -0.0072, -0.0036, 0.006, 0.0024, 0.0095, 0.0083, 0.0119, 0.0167, 0.0119, 0.0107, 0.0048, 0, -0.0048, 0.0012, 0.0036, 0, 0.006, 0.0048, 0.0036, -0.0036, -0.0155, -0.006, 0.0048, 0.0048, 0.0036, -0.0012, 0.0024, 0.0155, 0.0036, 0.0024, 0.0072, -0.0012, -0.006, 0.0024, 0.0083, 0.0095, 0, 0, 0.006, 0.0155, 0.0048, -0.0036, -0.0012, 0.0048, 0.006, 0.0012, 0.006, 0.0048, 0.006, 0.0155, 0.0143, 0.0024, -0.0012, 0.0036, 0.0131, 0.0083, 0.0024, 0.0024, 0.006, 0.0024, 0.0048, 0.0095, 0.0012, 0.0036, -0.0012, 0.0048, 0, 0.0036, 0.0024, 0.0107, 0.0083, 0.0036, 0.0083, 0.0024, 0.006, -0.0036, 0.0095, 0.0083, 0.0012, -0.0072, -0.0036, 0.0036, 0.0083, 0, -0.0012, 0.0036, 0.0012, 0.006, 0.0155, 0.0048, 0.0024, -0.0012, -0.0072, 0.0012, 0.0036, 0.0024, -0.0024, 0.006, 0.0083, -0.0012, 0.0036, 0.0083, 0.0048, 0.0143, 0.0215, 0.0155, 0.0143, 0.0083, 0.0155, 0.006, 0, 0.0036, 0.0155, 0.0095, 0.0155, 0.0107, 0.0083, 0.006, 0, -0.0083, -0.006, -0.0048, -0.0036, -0.0072, -0.0012, 0.0024, 0.0072, 0.0072, 0.0036, 0.0012, 0.0012, 0.006, 0.0107, 0.0119, 0.0083, -0.0012, 0.0036, 0.0072, 0.0036, 0.0048, 0.006, 0.0095, 0.0036, -0.0036, 0.0048, 0.0012, 0.0024, 0, 0, 0.0083, 0.0036, 0.0024, 0.0036, 0.006, 0.0036, 0, 0, 0.006, 0.0095, 0.0072, 0.0107, 0.0012, 0.0012, 0.0107, 0.0036, 0.0048, 0.0083, 0.0095, 0.006, 0.0036, 0.0036, 0.0095, 0.0095, 0.0072, 0.006, 0.0048, 0, 0.006, 0.0167, 0.0107, -0.0024, -0.0036, 0.0072, 0.0036, 0.0131, 0.0179, 0.0191, 0.0358, 0.025, 0.0322, 0.037, 0.0298, 0.0286, 0.0286, 0.0322, 0.0286, 0.0334, 0.0334, 0.0393, 0.0393, 0.056, 0.0632, 0.0548, 0.0656, 0.0679, 0.0775, 0.0823, 0.0882, 0.0954, 0.1073, 0.1287, 0.1419, 0.1478, 0.1419, 0.1431, 0.1514, 0.1824, 0.2134, 0.2217, 0.2301, 0.2611, 0.2766, 0.2921, 0.3076, 0.3278, 0.3481, 0.3648, 0.3934, 0.4196, 0.4363, 0.4506, 0.4828, 0.5114, 0.5341, 0.5627, 0.6032, 0.6235, 0.6402, 0.6521, 0.6783, 0.6962, 0.7176, 0.7451, 0.7677, 0.7808, 0.7999, 0.8154, 0.8249, 0.8368, 0.8512, 0.8726, 0.8762, 0.8798, 0.8965, 0.8976, 0.8965, 0.8893, 0.8905, 0.8845, 0.8702, 0.8678, 0.8619, 0.8547, 0.8428, 0.8273, 0.813, 0.7939, 0.7856, 0.7713, 0.7451, 0.7021, 0.6866, 0.6759, 0.6568, 0.6378, 0.6139, 0.5829, 0.546, 0.5198, 0.4947, 0.4792, 0.4518, 0.4315, 0.416, 0.4029, 0.3695, 0.3397, 0.3266, 0.3076, 0.2861, 0.267, 0.2456, 0.236, 0.2158, 0.1991, 0.1895, 0.1717, 0.1597, 0.1502, 0.1395, 0.1287, 0.1252, 0.1097, 0.0989, 0.0894, 0.0739, 0.0727, 0.0811, 0.0751, 0.0525, 0.0513, 0.0525, 0.0525, 0.0477, 0.0465, 0.0405, 0.0322, 0.031, 0.0238, 0.0191, 0.025, 0.0215, 0.0167, 0.0179, 0.0203, 0.0215, 0.0191, 0.0191, 0.0107, 0.0083, 0.0083, 0.0072, 0.0119, 0.0179, 0.0155, 0.006, -0.0036, 0.0083, 0.0036, -0.0012, 0.0095, 0.0119, 0.0131, 0.0131, 0.0107, 0.0012, -0.0095, -0.0036, 0.0095, 0.0048, -0.0024, 0.006, 0.0095, 0.0072, 0.0095, 0.0083, 0.0024, -0.0036, 0.0143, 0.0131, 0.0012, -0.0048, 0.0107, 0.0083, 0, 0.006, 0.0024, -0.0036, 0.006, 0.006, 0.0072, 0.0095, 0.0048, 0.0119, 0.0036, 0.0095, 0.0131, 0.0095, 0.0179, 0.025, 0.0131, 0.0072, 0.0143, 0.0167, 0.0107, 0.0131, 0.0036, 0.0072, 0.0107, 0.006, 0.006, 0.0155, 0.0167, 0.0131, 0.0048, -0.006, -0.0072, 0.006, 0.0095, 0.0036, 0.0036, 0.0119, 0.0048, 0, 0, 0.0036, 0.0083, -0.0048, 0, 0.0072, 0.0095, 0.0095, 0.0143, 0.0119, -0.0048, -0.0036, -0.0036, -0.0036, 0.0036, 0.0083, -0.006, 0.006, 0.0036, 0.006, 0.0083, 0.0167, 0.0215, 0.0095, 0.0072, 0.0072, 0.0024, -0.006, 0, 0, 0.0072, 0.0012, 0.006, 0.0048, -0.0012, 0.0072, 0.0095, 0.0048, 0.0024, -0.0036, 0.0095, 0.0131, 0, 0.0012, 0.0095, 0.0095, 0.0024, 0.0083, 0.006, 0.0012, 0.0036, 0, 0.0024, 0.0036, 0.0024, 0, 0.0036, 0.0119, 0.006, 0.0036, 0.0107, 0.0083, 0.0143, 0.0012, 0, 0.0119, 0.0226, 0.0322, 0.0179, 0.0072, 0.0179, 0.0131, 0.0226, 0.0286, 0.0286, 0.0346, 0.0405, 0.0429, 0.0441, 0.0536, 0.0584, 0.0703, 0.0811, 0.0823, 0.0882, 0.0966, 0.1216, 0.1359, 0.149, 0.1693, 0.2003, 0.2301, 0.2515, 0.2849, 0.3266, 0.366, 0.3934, 0.4339, 0.4828, 0.5364, 0.6151, 0.6819, 0.7463, 0.819, 0.9, 1.0026, 1.111, 1.2028, 1.3185, 1.4424, 1.5628, 1.6999, 1.8442, 1.9896, 2.1446, 2.3198, 2.4974, 2.6798, 2.8706, 3.0744, 3.2794, 3.4881, 3.7086, 3.9458, 4.1771, 4.4131, 4.6456, 4.8816, 5.1153, 5.3668, 5.6231, 5.8615, 6.1023, 6.3455, 6.5732, 6.8021, 7.0333, 7.2539, 7.4661, 7.6544, 7.8321, 8.0109, 8.1813, 8.3375, 8.4758, 8.5878, 8.6844, 8.7667, 8.8418, 8.8906, 8.9216, 8.9383, 8.9467, 8.9228, 8.8894, 8.8274, 8.7583, 8.6641, 8.5545, 8.4364, 8.2898, 8.1289, 7.9656, 7.7891, 7.5972, 7.4089, 7.205, 6.9749, 6.752, 6.5196, 6.2811, 6.0463, 5.8067, 5.554, 5.3096, 5.0628, 4.822, 4.5788, 4.3511, 4.1175, 3.8838, 3.6609, 3.4463, 3.2294, 3.0196, 2.8133, 2.6286, 2.4533, 2.284, 2.1136, 1.9646, 1.8132, 1.6701, 1.5426, 1.4126, 1.2934, 1.1897, 1.0824, 0.9811, 0.8869, 0.8142, 0.7403, 0.6723, 0.5972, 0.5233, 0.4745, 0.4292, 0.3827, 0.3433, 0.3135, 0.2766, 0.2432, 0.2229, 0.1895, 0.1669, 0.1514, 0.1347, 0.1311, 0.1061, 0.0739, 0.0739, 0.0584, 0.0525, 0.0596, 0.0572, 0.0441, 0.0358, 0.0298, 0.0226, 0.0191, 0.0191, 0.0203, 0.0143, 0.0143, 0.0179, 0.0274, 0.0226, 0.0131, 0.0083, 0.0131, 0.0107, 0.0024, -0.0036, -0.0024, 0.0048, 0.0083, 0.0012, 0.006, 0, -0.0024, -0.0036, 0.0012, -0.0012, -0.0072, -0.0072, -0.0107, 0.0036, 0.0048, 0.0024, 0.0012, -0.0024, -0.0012, 0, 0.0012, 0.006, 0.0036, 0.0048, 0.0024, 0.0036, 0.0024, -0.0012, 0.0048, -0.0012, 0, 0.0012, 0.0072, 0.0155, 0.0048, 0.0107, 0.0083, -0.0012, 0.0036, 0.0095, 0.0072, 0.006, -0.006, -0.0012, 0.006, 0.0083, -0.0024, -0.006, -0.0012, -0.0072, -0.0036, -0.0083, 0.0036, 0.0083, -0.0036, -0.0107, -0.0119, 0.0024, -0.0048, -0.0024, 0.0036, 0.006, 0.0095, -0.0048, 0.0036, 0.0072, -0.0024, -0.006, -0.0036, -0.0012, 0.006, 0.0107, 0.0012, 0.0072, 0.0072, 0.0095, 0.0072, 0.0072, 0.0131, 0.0107, 0.006, 0.0095, 0.0024, -0.0083, 0.0048, 0.006, 0.0072, 0.0107, -0.0048, -0.0072, -0.0024, 0.0048, 0, -0.0012, 0.0167, 0.0107, -0.0024, 0, 0.0036, 0.0036, 0, 0, 0.0143, 0.0012, 0.0048, 0.0167, 0.0131, 0.0131, 0.0131, 0.0095, 0.0119, 0.0155, 0.0191, 0.0167, 0.0167, 0.0143, 0.0226, 0.0262, 0.0298, 0.0358, 0.0346, 0.0548, 0.0548, 0.062, 0.0727, 0.0691, 0.0858, 0.1001, 0.1299, 0.1609, 0.186, 0.211, 0.242, 0.2778, 0.3254, 0.3731, 0.4292, 0.5007, 0.5782, 0.6771, 0.7737, 0.8678, 0.993, 1.1444, 1.3101, 1.4865, 1.688, 1.9205, 2.1613, 2.4307, 2.7633, 3.1173, 3.4893, 3.9136, 4.375, 4.8792, 5.4538, 6.0594, 6.7174, 7.4339, 8.2111, 9.0659, 9.9659, 10.9422, 12.008, 13.1404, 14.3325, 15.6236, 16.9802, 18.4143, 19.9258, 21.5256, 23.2196, 24.9779, 26.8245, 28.7545, 30.7536, 32.829, 34.9712, 37.1706, 39.4309, 41.7352, 44.0872, 46.4642, 48.8913, 51.3411, 53.7872, 56.2441, 58.7106, 61.1496, 63.5505, 65.918, 68.2402, 70.4944, 72.67, 74.7597, 76.7481, 78.6459, 80.4198, 82.078, 83.5812, 84.9414, 86.1549, 87.2111, 88.0861, 88.7918, 89.3414, 89.699, 89.8695, 89.8647, 89.6788, 89.2878, 88.7489, 88.0218, 87.1301, 86.0596, 84.8281, 83.4596, 81.948, 80.2755, 78.4886, 76.592, 74.5881, 72.4852, 70.2965, 68.0327, 65.7165, 63.349, 60.9314, 58.4841, 56.0308, 53.5786, 51.1265, 48.6767, 46.2639, 43.8738, 41.5242, 39.2282, 36.9787, 34.7829, 32.6502, 30.5855, 28.5923, 26.6683, 24.8289, 23.0777, 21.3945, 19.7911, 18.2819, 16.8526, 15.502, 14.2395, 13.0379, 11.9102, 10.8564, 9.8765, 8.9777, 8.1432, 7.3743, 6.6614, 6.0153, 5.4133, 4.8578, 4.3511, 3.8946, 3.4809, 3.0959, 2.7323, 2.4188, 2.1493, 1.8978, 1.6809, 1.4758, 1.2934, 1.1253, 0.9871, 0.8667, 0.7594, 0.6568, 0.5662, 0.4888, 0.4268, 0.3719, 0.3326, 0.2849, 0.2313, 0.1979, 0.1776, 0.1502, 0.1299, 0.1085, 0.1013, 0.0846, 0.0775, 0.0608, 0.056, 0.0441, 0.031, 0.025, 0.0203, 0.0167, 0.025, 0.0226, 0.025, 0.0215, 0.0226, 0.0203, 0.0143, 0.0107, 0.0119, 0.0095, 0.0024, 0.0036, 0.0012, -0.0048, -0.0012, 0.0024, 0.0024, 0.0072, 0, -0.0024, 0.0107, 0.0083, -0.0012, 0.0036, 0.0095, 0.0024, 0.0012, 0.0072, 0.0036, 0.0012, 0.0036, 0.0179, 0.0143, 0.0226, 0.0119, -0.0107, -0.0107, 0.0048, 0, -0.0072, -0.0048, -0.0119, -0.0024, 0.0131, 0.006, -0.0048, 0.0024, 0.0012, 0.006, 0.006, -0.0036, 0.0024, 0.0024, -0.0072, -0.0083, -0.0036, 0, 0.0048, 0.0072, 0.006, 0.0072, 0.0024, 0.0072, 0.0012, 0.0024, 0.006, 0.0048, 0, 0.0012, -0.0012, 0.006, 0.006, 0.0072, -0.0012, 0.0036, 0.0072, -0.0095, -0.0048, 0, -0.0072, 0.0024, 0, 0.0048, 0.0072, 0, 0.0024, 0.0095, 0.0095, 0.0036, 0.0012, -0.006, -0.0012, 0.0012, 0.0072, 0.0072, 0.0024, 0.0048, 0.0036, 0.0131, 0.0215, 0.0179, 0.0119, 0.0072, 0.0203, 0.0238, 0.0226, 0.0298, 0.0441, 0.0393, 0.0405, 0.0477, 0.0608, 0.087, 0.1061, 0.1299, 0.1562, 0.1872, 0.2158, 0.2611, 0.3076, 0.3672, 0.4399, 0.5186, 0.6294, 0.7427, 0.869, 1.0276, 1.2159, 1.4281, 1.6761, 1.9705, 2.3043, 2.6894, 3.1376, 3.6478, 4.2319, 4.9019, 5.6684, 6.5541, 7.5293, 8.6439, 9.9027, 11.3463, 12.9592, 14.7605, 16.7847, 19.0461, 21.5399, 24.3413, 27.4658, 30.9062, 34.7459, 39.0172, 43.6437, 48.703, 54.2462, 60.3437, 66.9348, 74.1196, 81.9385, 90.3392, 99.411, 109.1898, 119.7028, 130.9025, 142.8592, 155.6134, 169.189, 183.5513, 198.7052, 214.7079, 231.5187, 249.1021, 267.5271, 286.7043, 306.6277, 327.2903, 348.6299, 370.5847, 393.1081, 416.1668, 439.7035, 463.6061, 487.8557, 512.259, 536.809, 561.4114, 585.9339, 610.2717, 634.3806, 658.0734, 681.2382, 703.8212, 725.652, 746.6733, 766.7208, 785.7025, 803.5374, 820.1075, 835.3102, 849.0396, 861.2704, 871.8777, 880.8434, 888.1402, 893.6119, 897.311, 899.2433, 899.3232, 897.4778, 893.8586, 888.4645, 881.3381, 872.4523, 861.9344, 849.818, 836.1519, 821.0254, 804.5435, 786.7622, 767.8557, 747.8619, 726.9323, 705.1301, 682.5781, 659.436, 635.7872, 611.738, 587.3871, 562.8431, 538.249, 513.6895, 489.2337, 464.9937, 441.0863, 417.5389, 394.4397, 371.8853, 349.884, 328.5646, 307.8628, 287.8773, 268.6596, 250.2012, 232.5201, 215.6877, 199.6493, 184.4537, 170.0652, 156.4193, 143.6341, 131.6237, 120.3227, 109.8025, 99.9618, 90.8446, 82.376, 74.5726, 67.3497, 60.724, 54.6372, 49.0308, 43.9215, 39.2354, 35.001, 31.1553, 27.6613, 24.507, 21.6866, 19.2595, 17.004, 14.9715, 13.15, 11.5025, 10.0517, 8.7905, 7.6544, 6.6531, 5.7662, 4.9925, 4.307, 3.7193, 3.202, 2.7454, 2.3568, 2.0063, 1.7154, 1.4651, 1.2374, 1.0526, 0.8941, 0.7451, 0.627, 0.5329, 0.4423, 0.3779, 0.3159, 0.2623, 0.2193, 0.1907, 0.1574, 0.1287, 0.1097, 0.093, 0.0763, 0.0656, 0.0501, 0.0381, 0.0358, 0.037, 0.037, 0.0346, 0.0322, 0.0167, 0.0215, 0.0226, 0.025, 0.0048, -0.0024, -0.0012, 0.006, 0.0083, 0.0119, 0.0072, 0.0072, 0.0048, 0.0036, -0.0048, -0.006, 0.0012, -0.0072, -0.0048, 0.0083, 0.006, 0.0012, 0.0131, 0.0095, 0, 0.006, 0.0095, 0.0083, 0.0012, 0.0036, 0.006, -0.0012, 0.0024, 0.0119, 0.006, 0.0083, 0.0036, -0.0048, 0, 0.0048, 0.006, 0.0083, 0.0012, 0.0119, 0.0119, 0.0036, -0.0048, -0.0072, 0.0036, 0.0036, 0.0072, 0.0048, 0.0155, 0.0048, 0.0072, 0, 0.0072, 0.0191, 0.0107, 0.0131, 0.006, 0.0048, 0.0083, 0.0048, 0.006, 0.0083, 0.0083, -0.0012, -0.0024, 0.0048, 0.0143, 0.0107, -0.0024, -0.006, 0, 0.0179, 0.0262, 0.0203, 0.0226, 0.0226, 0.0215, 0.0191, 0.0274, 0.0346, 0.0417, 0.0429, 0.0644, 0.0751, 0.0882, 0.1132, 0.1371, 0.1848, 0.211, 0.2503, 0.3016, 0.3707, 0.4506, 0.5519, 0.67, 0.8094, 0.9882, 1.1945, 1.4567, 1.7416, 2.1017, 2.5272, 3.0339, 3.6275, 4.3404, 5.1796, 6.1429, 7.2896, 8.6427, 10.2127, 12.064, 14.1859, 16.6202, 19.4848, 22.8345, 26.7088, 31.1196, 36.2158, 42.0499, 48.7256, 56.3455, 65.0024, 74.8658, 85.9952, 98.5611, 112.7613, 128.7663, 146.7025, 166.7929, 189.2972, 214.3741, 242.2953, 273.2372, 307.5659, 345.484, 387.2407, 433.1648, 483.5844, 538.7318, 598.9719, 664.6359, 735.9409, 813.278, 896.8699, 987.0553, 1084.131, 1188.2842, 1299.8402, 1418.9231, 1545.8298, 1680.6388, 1823.5004, 1974.5839, 2133.7961, 2301.1553, 2476.5349, 2659.8621, 2850.9463, 3049.5476, 3255.3982, 3468.033, 3687.0254, 3911.9709, 4142.2402, 4377.1577, 4615.9209, 4857.7656, 5101.9536, 5347.5498, 5593.5552, 5838.9614, 6082.7671, 6324.0049, 6561.3472, 6793.7422, 7020.1006, 7239.3022, 7450.0859, 7651.4531, 7842.3164, 8021.6553, 8188.4419, 8341.7354, 8480.5547, 8604.1699, 8711.8193, 8802.9561, 8876.9834, 8933.3701, 8971.9082, 8992.3008, 8994.4316, 8978.3398, 8944, 8891.7275, 8821.8115, 8734.6621, 8630.8066, 8510.8809, 8375.6367, 8225.8193, 8062.2173, 7885.8184, 7697.624, 7498.5981, 7289.9961, 7072.7349, 6847.9668, 6616.9487, 6380.8428, 6140.5503, 5897.3501, 5652.2383, 5406.3369, 5160.6191, 4916.0469, 4673.5752, 4434.1851, 4198.4536, 3967.1111, 3740.8782, 3520.4304, 3306.2422, 3098.7214, 2898.3306, 2705.4392, 2520.2263, 2343.0251, 2173.8291, 2012.8131, 1859.8306, 1714.9961, 1578.2463, 1449.4204, 1328.4171, 1215.0216, 1109.0518, 1010.2832, 918.4182, 833.2252, 754.3862, 681.6483, 614.6395, 553.056, 496.6843, 445.137, 398.1614, 355.401, 316.5507, 281.3876, 249.6326, 221.0224, 195.2875, 172.1764, 151.4769, 133.0054, 116.564, 101.9144, 88.9528, 77.4431, 67.3258, 58.3744, 50.4935, 43.6294, 37.607, 32.3474, 27.7638, 23.7536, 20.2894, 17.3151, 14.8356, 12.641, 10.7133, 9.073, 7.6711, 6.4623, 5.4443, 4.5645, 3.8302, 3.2115, 2.6786, 2.2256, 1.8525, 1.5438, 1.2803, 1.055, 0.8762, 0.7248, 0.5877, 0.4923, 0.4113, 0.3278, 0.2682, 0.2277, 0.1848, 0.1562, 0.1347, 0.1144, 0.0966, 0.0727, 0.0536, 0.0584, 0.0417, 0.0334, 0.0358, 0.0393, 0.0322, 0.031, 0.0346, 0.0274, 0.0131, 0.0119, 0.0203, 0.0095, 0.0119, 0.0036, 0.0036, 0.0167, 0.0072, 0.0012, 0.0036, 0.0131, 0.0143, 0.0119, 0.0072, 0.0048, 0.0036, 0.0083, 0.0107, 0.0072, 0.0155, 0.0203, 0.0143, 0.0119, 0.0072, 0.0095, 0.0072, 0.0036, 0.0095, 0.0119, 0.006, 0.0119, 0.0036, 0.0143, 0.0095, 0.0131, 0.0155, 0.0167, 0.0131, -0.0024, 0.0024, 0.0036, 0.0095, 0.0036, 0.0048, 0.0107, 0.0012, 0.0083, 0.0107, 0.0119, 0.0119, 0.0012, 0.0012, 0.0048, 0.0119, 0.0095, 0.0012, 0.0036, 0.0024, 0.0072, 0.0107, 0.0048, 0, 0.0012, 0.0036, 0.0024, -0.0083, -0.0048, 0.0155, 0.0143, 0.006, 0.006, 0.0155, 0.0072, 0.0119, 0.0036, -0.0036, 0.0036, 0.0072, 0.0095, 0.006, 0.0036, 0.0024, 0.0048, -0.0012, 0.0095, 0.0143, 0.0095, 0.0179, 0.0131, 0.0119, 0.0083, 0.0107, 0.0048, 0.006, 0.0072, -0.0024, 0.0036, 0.0095, 0.0036, 0.0024, 0.0036, 0.0072, 0.0131, 0.0072, 0.0167, 0.006, 0.0072, 0.006, 0.0119, 0.0048, 0, 0.0036, 0.0048, 0.0012, 0.006, 0.0072, 0.0048, 0.0131, 0.0155, 0.0203, 0.006, 0.0024, 0.0012, 0.0048, 0.0012, 0.006, 0.006, 0.0155, 0.0119, 0.0036, 0.0072, 0.0083, 0.0024, 0.0095, 0.0083, 0, 0.0024, 0.006, 0.0024, 0.006, 0, -0.0036, 0.0072, 0.006, 0.0024, 0.0012, 0.006, 0.0072, 0.006, -0.0024, 0.0048, 0.0083, -0.0048, -0.0083, -0.0036, 0.0083, 0.0095, 0, 0.0048, 0.0155, 0.0131, 0.0012, 0.0083, 0.0095, -0.0048, 0.0083, 0.0119, 0.0012, 0.0024, -0.0024, 0.0012, 0.0024, -0.0095, -0.006, 0.0036, 0.0072, 0.0072, 0.0107, 0.0012, 0.0095, 0.0131, 0.0131]
		SetName("My RID Detector")
		SetHideLoadMethod(false)
		SetTimerPeriod($timerPeriod)
	
		#Polarity status if it is Normal (Positive peaks) or Inverted (Negative peaks)
		@polarityStatusList=ChoiceList.new(Method(),"SignalPolarity","Signal Polarity",0,$polarity,"")
		@polarityStatus=@polarityStatusList.getCurValue()
		
		#Status of RID cell purging, if purging is On or Off
		@isPurging=false
		
		#for peak generation	
		@rateList=ChoiceList.new(Method(),"SampleRate", "Sample Rate",0,$rate,"")
		@rate=@rateList.getCurValue().to_f
		#A counter that will tick every 1000ms ($timerPeriod value), every 7 ticks (7 seconds) will create a peak
		#Used with method (GenerateSignalsAndPeaks)
		@peak_counter=1
		#A flag that will be true when @peak_counter%7==0, every 7 ticks
		@detect_peak=false
		#A random range of numbers that will be multiplied by the written signal value to control height of randomely created peaks
		#Used with method (GenerateSignalsAndPeaks)
		@signal_factor=1
		#A variable that is used on detecting peaks to iterate through peaks arrays (@peak, @complete_chromatogram)
		@array_index=0
		
		#Measure time difference, used to control the peak rate
		@timeCount=0
		
		@m_Detector = Detector.new
		@m_Detector.SetName(Configuration().GetString("DetectorName"))
		@m_Detector.SetRate(@rate)
		AddSubDevice(@m_Detector)
		@m_Detector.SetYUnits("uV","mV", true, 1)

		
		
		if(Configuration().GetInt("SetTempFromMethod")==1)
			Method().AddDouble("SetTemp", "Temperature", ConvertTemperature(35.0,ETU_C,ETU_K), 1, EMeaningTemperature, "VerifyTemp")
			Method().AddCheckBox("EnableStartAnyTemp", "Enable start at any temperature", false)
			Method().AddDouble("SetTempTolerance", "Temperature Tolerance", 0.2, 1, EMeaningTemperatureDifference, "VerifyTempTolerance")
		end
		
		
		Method().AddCheckBox("EnableAutoZero", "AutoZero before start", true)

		
		Monitor().AddButton("AutoZeroButton", "AutoZero", "Perform","AutoZeroAction")
		Monitor().AddButton("PurgeButton", "Purge Cell", "On/Off","PurgeAction")
		Monitor().AddDouble("CurrTemp", "Current Temperature", GetDetectorTemp(), 1, EMeaningTemperature,"",true)
		Monitor().AddDouble("SetMethodTemp", "Set Temperature", Method().GetDouble("SetTemp"), 1, EMeaningTemperature,"",true)
		Monitor().AddDouble("OpticalBalance", "Optical Balance[%]", 0.0, 1, EMeaningUnknown,"",true)
		Monitor().AddDouble("DetectorSignal", "Detector Signal[mV]", 0.000, 3, EMeaningUnknown,"",true)
		Monitor().AddButton("PolaritySwitchButton", "Polarity Of Signal", @polarityStatus,"PolarityAction")
		Monitor().Synchronize()

		AuxSignal().AddSignal('DetectorTemperature', "RID Temperature",EMeaningTemperature)
		AuxSignal().AddSignal('DetectorS', "RID",EMeaningUnknown)
	end
	
	def GetMethodRate(method)
		return @rate
	end
	
	def GetMethodRange(method)
		return 10000.0
	end
	
	def InitCommunication()
		# Set number of pipe configurations for communication. In our case one - serial communication.
		Communication().SetPipeConfigCount(1)
		# Set type for created pipe configuration.
		Communication().GetPipeConfig(0).SetType(EPT_SERIAL)
		Communication().GetPipeConfig(0).SetBaudRate(9600)
		Communication().GetPipeConfig(0).SetParity(NOPARITY)
		Communication().GetPipeConfig(0).SetDataBits(DATABITS_8)
		Communication().GetPipeConfig(0).SetStopBits(ONESTOPBIT)
	end
	
	def FindFrame(dataArraySent, dataArrayReceived)
		# Search for frame end
		nEndFrameIdx = dataArrayReceived.index($cmdEndChar)
		if (nEndFrameIdx == nil)
			return false  
		end
		
		# Set frame start and end indexes.
		SetFrameStart(0)
		SetFrameEnd(nEndFrameIdx)
		return true
	end
	
	def IsItAnswer(dataArraySent, dataArrayReceived)
		return true
	end

	def CmdGetSN()
		return true
	end
	
	def CmdOpenInstrument
		return true
	end
	
	def CmdCloseInstrument
		return true
	end
	
	def CmdStartSequence
		return true
	end
	
	def CmdResumeSequence
		return true
	end
	
	def CmdStartRun
		return true
	end
	
	def CmdPerformInjection
		return true
	end
	
	def CmdByPassInjection
		return true
	end
	
	def CmdStartAcquisition
		Monitor.SetState("Running")
		Monitor().SetButtonEnable("AutoZeroButton",false)
		Monitor().SetButtonEnable("PurgeButton",false)
		Monitor().SetButtonEnable("PolaritySwitchButton",false)
		Monitor().SetRunning(true)
		@timeCount=0
		Monitor().Synchronize()
		return true
	end
	
	def CmdRestartAcquisition
		return true
	end
	
	def CmdStopAcquisition
		if (Monitor().IsRunning()==true)
			Monitor().SetButtonEnable("AutoZeroButton",true)
			Monitor().SetButtonEnable("PurgeButton",true)
			Monitor().SetButtonEnable("PolaritySwitchButton",true)
			Monitor().SetRunning(false)
			@peak_counter=1
			@detect_peak=false
			@signal_factor=1
			@array_index=0
			Monitor().SetRunning(false)
			@timeCount=0
			Trace("Acquisition stopped")
			Monitor().Synchronize()
		end
		return true
	end
	
	def CmdAbortRunError
		if (Monitor().IsRunning()==true)
			return CmdStopAcquisition()
		end
		return true
	end
	
	def CmdAbortRunUser
		if (Monitor().IsRunning()==true)
			return CmdStopAcquisition()
		end
		return true
	end
	
	def CmdShutDown
		CmdAbortRunError()
		return true
	end
	
	def CmdStopRun
		return true
	end
	
	def CmdStopSequence
		return true
	end
	
	def CmdTestConnect
		return true
	end
	
	def ParseReceivedFrame(dataArrayReceived) 
	end
	
	def CmdSendMethod
		Monitor().SetDouble("SetMethodTemp",Method().GetDouble("SetTemp"))
		@rate=@rateList.getCurValue().to_f
		@m_Detector.SetRate(@rate)
		@polarityStatus=@polarityStatusList.getCurValue()
		Trace("Rate="+@rate.to_s)
		Trace("Polarity="+@polarityStatus)
		
		SetDetectorTemp(Method().GetDouble("SetTemp"))
		
		Monitor().Synchronize()
		return true
	end
	
	def CmdLoadMethod(method)
		return true
	end
	
	def GetMethodLength
		return  METHOD_FINISHED
	end
	
	def CmdTimer
		Monitor().Synchronize()
		#always write temperature signal whether the monitor is running or not
		AuxSignal().WriteSignal("DetectorTemperature",Monitor().GetDouble("CurrTemp"))
		
		#Always write signal, this method will generate a peak every 7 rounds, then normal noise
		#Choose to generate peak every 7 seconds (can be changed) or using a ready to use chromatogram array
		GenerateSignalsAndPeaks()
		#GenerateCompleteChromatogram()
		
		#adjust temperature first, the device will not give you ready state until the temperature stabilize
		#Purging RID cell will not be active until temperature stabilize
		if((Method().GetDouble("SetTemp")-Monitor().GetDouble("CurrTemp")).abs()>Method().GetDouble("SetTempTolerance"))
			Monitor().SetReady(false)
			Monitor().SetStateName("Equilibrating temperature")
			Monitor().SetButtonEnable("PurgeButton",false)
			curr_temp=Monitor().GetDouble("CurrTemp")
			curr_temp>Method().GetDouble("SetTemp") ? curr_temp-=rand(0.5..0.8) : curr_temp+=rand(0.5..0.8)
			Monitor().SetDouble("CurrTemp",curr_temp)
			
			
			return false
		end
		
		
		#method can't be sent if purging is in action, this is made to avoid mobile phase to purge the detector cell with a difference in temperature
		if(!Monitor().IsRunning())
			Monitor().SetButtonEnable("PurgeButton",true)
		end
		
		if(!@isPurging)
			Monitor().SetReady(true)
			Monitor().SetStateName("Ready")
		else
			Monitor().SetReady(false)
			Monitor().SetStateName("Purging RID Cell")
		end
		
		return true
	end
	def GenerateSignalsAndPeaks
		signal=0
		if (@detect_peak==false)
			@array_index=0
			@detect_peak=false
			signal=rand(0.03..0.04)
			#the counter (7 seconds) will not start if the device is not running or if a peak is created
			@peak_counter+=Monitor().IsRunning()? 1 : 0
			AuxSignal().WriteSignal("DetectorS",signal*(@polarityStatus=="Normal" ? 1 : -1))

		end
		if(@peak_counter%7==0 && @detect_peak==false && Monitor().IsRunning())
			Trace("Peak detected")
			@detect_peak=true
			#a factor which controls the peak height
			@signal_factor=rand(0.5..10)
		end
		if(@detect_peak==true)
			if(@array_index<@peak.length)
				signal=@peak[@array_index]*@signal_factor
				#A code to control the rate of peaks
				timeNow=Process.clock_gettime(Process::CLOCK_MONOTONIC)
				if(@timeCount==0)
					@timeCount=timeNow
				end
				timeDiff=timeNow-@timeCount
				if(timeDiff>0)
					multiply=(timeDiff*@rate).to_i
			
					for i in 0...multiply
						AuxSignal().WriteSignal("DetectorS",signal*(@polarityStatus=="Normal" ? 1 : -1))
						Trace("Signal now is: "+(signal*(@polarityStatus=="Normal" ? 1 : -1)).to_s+" for "+(i+1).to_s+" times")
					end
					@timeCount = @timeCount + multiply / @rate.to_f
					
				end
				@array_index+=1
			else
				Trace("Back to normal")
				@detect_peak=false
			end
		end
		
		
		Monitor().SetDouble("DetectorSignal",signal*(@polarityStatus=="Normal" ? 1 : -1))
		
		return true
	end
	
	def GenerateCompleteChromatogram
		if(Monitor().IsRunning()==true)
			if(@array_index<@complete_chromatogram.length)
			
				signal=@complete_chromatogram[@array_index]
				timeNow=Process.clock_gettime(Process::CLOCK_MONOTONIC)
				if(@timeCount==0)
					@timeCount=timeNow
				end
			
				timeDiff=timeNow-@timeCount
				if(timeDiff>0)
					multiply=(timeDiff*@rate).to_i
			
					for i in 0...multiply
						AuxSignal().WriteSignal("DetectorS",signal*(@polarityStatus=="Normal" ? 1 : -1))
						Trace("Signal now is: "+(signal*(@polarityStatus=="Normal" ? 1 : -1)).to_s+" for "+(i+1).to_s+" times")
					end
					@timeCount = @timeCount + multiply / @rate.to_f
					
				end
				@array_index+=1
			else
				Trace("Chromatogram ended")
				CmdStopAcquisition()
			end
		else
			signal=rand(0.03..0.04)
			AuxSignal().WriteSignal("DetectorS",signal*(@polarityStatus=="Normal" ? 1 : -1))
		end
	end
	
	def CmdAutoDetect
		return true
	end
	
	def NotifyChromatogramFileName(chromatogramFileName)
	end
	
	def CheckMethod(situation, method) 
		return true
	end
	
	def GetDetectorTemp()
		if(IsDemo())
			return ConvertTemperature(40.0,ETU_C,ETU_K)
			#in real devices, this code is to be removed
		end
		cmd=CommandWrapper.new(self)
		cmd.AppendANSIString("G:")
		if(cmd.SendCommand($timeOut)==false)
			return false
		end
		if(cmd.ParseANSIString("OK/")==false)
			return false
		end
		
		if((curr_temp=cmd.ParseANSIDouble())==false)
			return false
		end
		return ConvertTemperature(curr_temp,ETU_C,ETU_K)
	end
	
	def SetDetectorTemp(temp)
		if(IsDemo())
			return true
		end
		cmd=CommandWrapper.new(self)
		cmd.AppendANSIString("S:")
		cmd.AppendANSIDouble(temp)
		if(cmd.SendCommand($timeOut)==false)
			return false
		end
		if(cmd.ParseANSIString("OK/")==false)
			return false
		end
		return true
	end
	
	def VerifyDetectorName(uiitemcollection,value)
		if (value.length>32 || value.length==0)
			return "Name length should not be empty, not more than 32 characters"
		end
		return true
	end
	
	def VerifyTemp(uiitemcollection,value)
		if(@isPurging)
			return "Can't change temperature while purging the cell, please turn off purging first"
		end
		if (value < ConvertTemperature(30.0,ETU_C,ETU_K) || value > ConvertTemperature(45.0,ETU_C,ETU_K))
			tempMin = ConvertTemperature(30.0, ETU_C, GetTemperatureUIUnits())
			tempMax = ConvertTemperature(45.0, ETU_C, GetTemperatureUIUnits())
			return "Value must be between "+tempMin.to_s+" and "+tempMax.to_s
		end
		
		if(IsDemo())
			return true
		end
		
		SetDetectorTemp(value)
		return true
	end
	
	def VerifyTempTolerance(uiitemcollection,value)
		if(@isPurging)
			return "Can't change temperature tolerance while purging the cell, please turn off purging first"
		end
		if (value < 0.1 || value > 5.0)
			tolMin = ConvertTemperature(0.1, ETU_C, GetTemperatureUIUnits()) - ConvertTemperature(0.0, ETU_C, GetTemperatureUIUnits())
			tolMax = ConvertTemperature(5.0, ETU_C, GetTemperatureUIUnits()) - ConvertTemperature(0.0, ETU_C, GetTemperatureUIUnits())
			return "Value must be between "+tolMin.to_s+" and "+tolMax.to_s
		end
		return true
	end
	
	def AutoZeroAction()
		#no need in demo version
		if(IsDemo())
			return true
		end
		cmd=CommandWrapper.new(self)
		cmd.AppendANSIString("Z:")
		if(cmd.SendCommand($timeOut)==false)
			return false
		end
		if(cmd.ParseANSIString("OK/")==false)
			return false
		end
	end
	
	def PurgeAction()
		if(@isPurging==false)
			@isPurging=true
		else
			@isPurging=false
		end
		Monitor().Synchronize()
	end
	
	def PolarityAction()
		if(@polarityStatus=="Normal")
			@polarityStatus="Inverted"
		else
			@polarityStatus="Normal"
		end
		Monitor().Synchronize()
	end
end