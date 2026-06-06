$begin 'Profile'
	$begin 'ProfileGroup'
		MajorVer=2024
		MinorVer=2
		Name='Solution Process'
		$begin 'StartInfo'
			I(1, 'Start Time', '04/18/2026 19:42:54')
			I(1, 'Host', 'DESKTOP-SB5LH8U')
			I(1, 'Processor', '32')
			I(1, 'OS', 'NT 10.0')
			I(1, 'Product', 'HFSS Version 2024.2.0')
		$end 'StartInfo'
		$begin 'TotalInfo'
			I(1, 'Elapsed Time', '00:01:45')
			I(1, 'ComEngine Memory', '183 M')
		$end 'TotalInfo'
		GroupOptions=8
		TaskDataOptions('CPU Time'=8, Memory=8, 'Real Time'=8)
		ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 1, \'Executing From\', \'P:\\\\HFSS\\\\v242\\\\Win64\\\\HFSSCOMENGINE.exe\')', false, true)
		$begin 'ProfileGroup'
			MajorVer=2024
			MinorVer=2
			Name='HPC'
			$begin 'StartInfo'
				I(1, 'Type', 'Auto')
				I(1, 'MPI Vendor', 'Intel')
				I(1, 'MPI Version', '2021')
			$end 'StartInfo'
			$begin 'TotalInfo'
				I(0, ' ')
			$end 'TotalInfo'
			GroupOptions=0
			TaskDataOptions(Memory=8)
			ProfileItem('Machine', 0, 0, 0, 0, 0, 'I(5, 1, \'Name\', \'DESKTOP-SB5LH8U\', 1, \'Memory\', \'31.7 GB\', 3, \'RAM Limit\', 90, \'%f%%\', 2, \'Cores\', 4, false, 1, \'Free Disk Space\', \'261 GB\')', false, true)
		$end 'ProfileGroup'
		ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 1, \'Allow off core\', \'True\')', false, true)
		ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 1, \'Solution Basis Order\', \'1\')', false, true)
		ProfileItem('Design Validation', 0, 0, 0, 0, 0, 'I(1, 0, \'Elapsed time : 00:00:00 , HFSS ComEngine Memory : 174 M\')', false, true)
		ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Perform full validations with standard port validations\')', false, true)
		ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'\')', false, true)
		$begin 'ProfileGroup'
			MajorVer=2024
			MinorVer=2
			Name='Initial Meshing'
			$begin 'StartInfo'
				I(1, 'Time', '04/18/2026 19:42:54')
			$end 'StartInfo'
			$begin 'TotalInfo'
				I(1, 'Elapsed Time', '00:00:01')
			$end 'TotalInfo'
			GroupOptions=4
			TaskDataOptions('CPU Time'=8, Memory=8, 'Real Time'=8)
			ProfileItem('Mesh', 0, 0, 0, 0, 34288, 'I(2, 1, \'Type\', \'Phi\', 2, \'Tetrahedra\', 732, false)', true, true)
			ProfileItem('Post', 0, 0, 0, 0, 36160, 'I(2, 2, \'Tetrahedra\', 732, false, 2, \'Cores\', 1, false)', true, true)
			ProfileItem('Lambda Refine', 0, 0, 0, 0, 31120, 'I(2, 2, \'Tetrahedra\', 3778, false, 2, \'Cores\', 1, false)', true, true)
			ProfileItem('Simulation Setup', 0, 0, 0, 0, 182916, 'I(1, 1, \'Disk\', \'0 Bytes\')', true, true)
			ProfileItem('Port Adapt', 0, 0, 0, 0, 196116, 'I(2, 2, \'Tetrahedra\', 3744, false, 1, \'Disk\', \'5.72 KB\')', true, true)
			ProfileItem('Port Refine', 0, 0, 0, 0, 25432, 'I(2, 2, \'Tetrahedra\', 4069, false, 2, \'Cores\', 1, false)', true, true)
		$end 'ProfileGroup'
		$begin 'ProfileGroup'
			MajorVer=2024
			MinorVer=2
			Name='Adaptive Meshing'
			$begin 'StartInfo'
				I(1, 'Time', '04/18/2026 19:42:56')
			$end 'StartInfo'
			$begin 'TotalInfo'
				I(1, 'Elapsed Time', '00:00:57')
			$end 'TotalInfo'
			GroupOptions=4
			TaskDataOptions('CPU Time'=8, Memory=8, 'Real Time'=8)
			$begin 'ProfileGroup'
				MajorVer=2024
				MinorVer=2
				Name='Adaptive Pass 1'
				$begin 'StartInfo'
					I(0, 'Multi-Frequency Adaptive Meshing')
				$end 'StartInfo'
				$begin 'TotalInfo'
					I(0, ' ')
				$end 'TotalInfo'
				GroupOptions=0
				TaskDataOptions('CPU Time'=8, Memory=8, 'Real Time'=8)
				ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Solving Distributed - up to 2 frequencies in parallel\')', false, true)
				ProfileItem(' ', 0, 0, 0, 0, 0, 'I(1, 0, \'\')', false, true)
				$begin 'ProfileGroup'
					MajorVer=2024
					MinorVer=2
					Name='Frequency - 21GHz'
					$begin 'StartInfo'
						I(0, 'DESKTOP-SB5LH8U')
					$end 'StartInfo'
					$begin 'TotalInfo'
						I(0, 'Elapsed time : 00:00:01')
					$end 'TotalInfo'
					GroupOptions=0
					TaskDataOptions('CPU Time'=8, 'Real Time'=8)
					ProfileItem(' ', 0, 0, 0, 0, 0, 'I(1, 0, \'\')', false, true)
					ProfileItem('Simulation Setup ', 0, 0, 0, 0, 212088, 'I(2, 2, \'Tetrahedra\', 3923, false, 1, \'Disk\', \'4.55 KB\')', true, false)
					ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Port 1 supports an additional propagating and/or slowly decaying mode whose attenuation is   3.039e-01 and propagation constant is   6.309e+02\')', false, true)
					ProfileItem('Matrix Assembly', 0, 0, 0, 0, 234708, 'I(3, 2, \'Tetrahedra\', 3923, false, 2, \'1 Triangles\', 92, false, 1, \'Disk\', \'1 Bytes\')', true, false)
					ProfileItem('Matrix Solve', 0, 0, 0, 0, 309260, 'I(5, 1, \'Type\', \'DCS\', 2, \'Cores\', 2, false, 2, \'Matrix size\', 23795, false, 3, \'Matrix bandwidth\', 18.7104, \'%5.1f\', 1, \'Disk\', \'2.22 KB\')', true, false)
					ProfileItem('Field Recovery', 0, 0, 0, 0, 309260, 'I(2, 2, \'Excitations\', 1, false, 1, \'Disk\', \'1.6 MB\')', true, false)
				$end 'ProfileGroup'
				$begin 'ProfileGroup'
					MajorVer=2024
					MinorVer=2
					Name='Frequency - 8GHz'
					$begin 'StartInfo'
						I(0, 'DESKTOP-SB5LH8U')
					$end 'StartInfo'
					$begin 'TotalInfo'
						I(0, 'Elapsed time : 00:00:01')
					$end 'TotalInfo'
					GroupOptions=0
					TaskDataOptions('CPU Time'=8, 'Real Time'=8)
					ProfileItem('Simulation Setup ', 0, 0, 0, 0, 212756, 'I(2, 2, \'Tetrahedra\', 3923, false, 1, \'Disk\', \'4.55 KB\')', true, false)
					ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Port 1 supports an additional propagating and/or slowly decaying mode whose attenuation is   1.514e-01 and propagation constant is   1.838e+02\')', false, true)
					ProfileItem('Matrix Assembly', 0, 0, 0, 0, 235204, 'I(3, 2, \'Tetrahedra\', 3923, false, 2, \'1 Triangles\', 92, false, 1, \'Disk\', \'0 Bytes\')', true, false)
					ProfileItem('Matrix Solve', 0, 0, 0, 0, 310520, 'I(5, 1, \'Type\', \'DCS\', 2, \'Cores\', 2, false, 2, \'Matrix size\', 23795, false, 3, \'Matrix bandwidth\', 18.7104, \'%5.1f\', 1, \'Disk\', \'2.22 KB\')', true, false)
					ProfileItem('Field Recovery', 0, 0, 0, 0, 310520, 'I(2, 2, \'Excitations\', 1, false, 1, \'Disk\', \'1.6 MB\')', true, false)
				$end 'ProfileGroup'
				ProfileItem('Data Transfer', 0, 0, 0, 0, 179216, 'I(1, 0, \'Adaptive Pass 1\')', true, true)
			$end 'ProfileGroup'
			ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'\')', false, true)
			$begin 'ProfileGroup'
				MajorVer=2024
				MinorVer=2
				Name='Adaptive Pass 2'
				$begin 'StartInfo'
					I(0, 'Multi-Frequency Adaptive Meshing')
				$end 'StartInfo'
				$begin 'TotalInfo'
					I(0, ' ')
				$end 'TotalInfo'
				GroupOptions=0
				TaskDataOptions('CPU Time'=8, Memory=8, 'Real Time'=8)
				ProfileItem('Adaptive Refine', 0, 0, 0, 0, 28252, 'I(2, 2, \'Tetrahedra\', 5064, false, 2, \'Cores\', 1, false)', true, true)
				ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Solving Distributed - up to 2 frequencies in parallel\')', false, true)
				ProfileItem(' ', 0, 0, 0, 0, 0, 'I(1, 0, \'\')', false, true)
				$begin 'ProfileGroup'
					MajorVer=2024
					MinorVer=2
					Name='Frequency - 21GHz'
					$begin 'StartInfo'
						I(0, 'DESKTOP-SB5LH8U')
					$end 'StartInfo'
					$begin 'TotalInfo'
						I(0, 'Elapsed time : 00:00:01')
					$end 'TotalInfo'
					GroupOptions=0
					TaskDataOptions('CPU Time'=8, 'Real Time'=8)
					ProfileItem(' ', 0, 0, 0, 0, 0, 'I(1, 0, \'\')', false, true)
					ProfileItem('Simulation Setup ', 0, 0, 0, 0, 214820, 'I(2, 2, \'Tetrahedra\', 4918, false, 1, \'Disk\', \'3.4 KB\')', true, false)
					ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Port 1 supports an additional propagating and/or slowly decaying mode whose attenuation is   3.039e-01 and propagation constant is   6.309e+02\')', false, true)
					ProfileItem('Matrix Assembly', 0, 0, 0, 0, 241952, 'I(3, 2, \'Tetrahedra\', 4918, false, 2, \'1 Triangles\', 92, false, 1, \'Disk\', \'6 Bytes\')', true, false)
					ProfileItem('Matrix Solve', 0, 0, 0, 0, 337056, 'I(5, 1, \'Type\', \'DCS\', 2, \'Cores\', 2, false, 2, \'Matrix size\', 29599, false, 3, \'Matrix bandwidth\', 18.9358, \'%5.1f\', 1, \'Disk\', \'23.9 KB\')', true, false)
					ProfileItem('Field Recovery', 0, 0, 0, 0, 337056, 'I(2, 2, \'Excitations\', 1, false, 1, \'Disk\', \'1.56 MB\')', true, false)
				$end 'ProfileGroup'
				$begin 'ProfileGroup'
					MajorVer=2024
					MinorVer=2
					Name='Frequency - 8GHz'
					$begin 'StartInfo'
						I(0, 'DESKTOP-SB5LH8U')
					$end 'StartInfo'
					$begin 'TotalInfo'
						I(0, 'Elapsed time : 00:00:01')
					$end 'TotalInfo'
					GroupOptions=0
					TaskDataOptions('CPU Time'=8, 'Real Time'=8)
					ProfileItem('Simulation Setup ', 0, 0, 0, 0, 215212, 'I(2, 2, \'Tetrahedra\', 4918, false, 1, \'Disk\', \'3.4 KB\')', true, false)
					ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Port 1 supports an additional propagating and/or slowly decaying mode whose attenuation is   1.514e-01 and propagation constant is   1.838e+02\')', false, true)
					ProfileItem('Matrix Assembly', 0, 0, 0, 0, 241812, 'I(3, 2, \'Tetrahedra\', 4918, false, 2, \'1 Triangles\', 92, false, 1, \'Disk\', \'7 Bytes\')', true, false)
					ProfileItem('Matrix Solve', 0, 0, 0, 0, 337104, 'I(5, 1, \'Type\', \'DCS\', 2, \'Cores\', 2, false, 2, \'Matrix size\', 29599, false, 3, \'Matrix bandwidth\', 18.9358, \'%5.1f\', 1, \'Disk\', \'23.8 KB\')', true, false)
					ProfileItem('Field Recovery', 0, 0, 0, 0, 337104, 'I(2, 2, \'Excitations\', 1, false, 1, \'Disk\', \'1.56 MB\')', true, false)
				$end 'ProfileGroup'
				ProfileItem('Data Transfer', 0, 0, 0, 0, 179812, 'I(1, 0, \'Adaptive Pass 2\')', true, true)
				ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 3, \'Max Mag. Delta S\', 0.889444, \'%.5f\')', false, true)
			$end 'ProfileGroup'
			ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'\')', false, true)
			$begin 'ProfileGroup'
				MajorVer=2024
				MinorVer=2
				Name='Adaptive Pass 3'
				$begin 'StartInfo'
					I(0, 'Multi-Frequency Adaptive Meshing')
				$end 'StartInfo'
				$begin 'TotalInfo'
					I(0, ' ')
				$end 'TotalInfo'
				GroupOptions=0
				TaskDataOptions('CPU Time'=8, Memory=8, 'Real Time'=8)
				ProfileItem('Adaptive Refine', 0, 0, 0, 0, 29744, 'I(2, 2, \'Tetrahedra\', 6545, false, 2, \'Cores\', 1, false)', true, true)
				ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Solving Distributed - up to 2 frequencies in parallel\')', false, true)
				ProfileItem(' ', 0, 0, 0, 0, 0, 'I(1, 0, \'\')', false, true)
				$begin 'ProfileGroup'
					MajorVer=2024
					MinorVer=2
					Name='Frequency - 21GHz'
					$begin 'StartInfo'
						I(0, 'DESKTOP-SB5LH8U')
					$end 'StartInfo'
					$begin 'TotalInfo'
						I(0, 'Elapsed time : 00:00:01')
					$end 'TotalInfo'
					GroupOptions=0
					TaskDataOptions('CPU Time'=8, 'Real Time'=8)
					ProfileItem(' ', 0, 0, 0, 0, 0, 'I(1, 0, \'\')', false, true)
					ProfileItem('Simulation Setup ', 0, 0, 0, 0, 218644, 'I(2, 2, \'Tetrahedra\', 6399, false, 1, \'Disk\', \'3.4 KB\')', true, false)
					ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Port 1 supports an additional propagating and/or slowly decaying mode whose attenuation is   3.039e-01 and propagation constant is   6.309e+02\')', false, true)
					ProfileItem('Matrix Assembly', 0, 0, 0, 0, 252148, 'I(3, 2, \'Tetrahedra\', 6399, false, 2, \'1 Triangles\', 92, false, 1, \'Disk\', \'0 Bytes\')', true, false)
					ProfileItem('Matrix Solve', 0, 0, 0, 0, 385724, 'I(5, 1, \'Type\', \'DCS\', 2, \'Cores\', 2, false, 2, \'Matrix size\', 38447, false, 3, \'Matrix bandwidth\', 19.3065, \'%5.1f\', 1, \'Disk\', \'35.7 KB\')', true, false)
					ProfileItem('Field Recovery', 0, 0, 0, 0, 385724, 'I(2, 2, \'Excitations\', 1, false, 1, \'Disk\', \'2 MB\')', true, false)
				$end 'ProfileGroup'
				$begin 'ProfileGroup'
					MajorVer=2024
					MinorVer=2
					Name='Frequency - 8GHz'
					$begin 'StartInfo'
						I(0, 'DESKTOP-SB5LH8U')
					$end 'StartInfo'
					$begin 'TotalInfo'
						I(0, 'Elapsed time : 00:00:01')
					$end 'TotalInfo'
					GroupOptions=0
					TaskDataOptions('CPU Time'=8, 'Real Time'=8)
					ProfileItem('Simulation Setup ', 0, 0, 0, 0, 218716, 'I(2, 2, \'Tetrahedra\', 6399, false, 1, \'Disk\', \'3.4 KB\')', true, false)
					ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Port 1 supports an additional propagating and/or slowly decaying mode whose attenuation is   1.514e-01 and propagation constant is   1.838e+02\')', false, true)
					ProfileItem('Matrix Assembly', 0, 0, 0, 0, 252488, 'I(3, 2, \'Tetrahedra\', 6399, false, 2, \'1 Triangles\', 92, false, 1, \'Disk\', \'0 Bytes\')', true, false)
					ProfileItem('Matrix Solve', 0, 0, 0, 0, 386024, 'I(5, 1, \'Type\', \'DCS\', 2, \'Cores\', 2, false, 2, \'Matrix size\', 38447, false, 3, \'Matrix bandwidth\', 19.3065, \'%5.1f\', 1, \'Disk\', \'35.7 KB\')', true, false)
					ProfileItem('Field Recovery', 0, 0, 0, 0, 386024, 'I(2, 2, \'Excitations\', 1, false, 1, \'Disk\', \'2 MB\')', true, false)
				$end 'ProfileGroup'
				ProfileItem('Data Transfer', 0, 0, 0, 0, 177136, 'I(1, 0, \'Adaptive Pass 3\')', true, true)
				ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 3, \'Max Mag. Delta S\', 0.248036, \'%.5f\')', false, true)
			$end 'ProfileGroup'
			ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'\')', false, true)
			$begin 'ProfileGroup'
				MajorVer=2024
				MinorVer=2
				Name='Adaptive Pass 4'
				$begin 'StartInfo'
					I(0, 'Multi-Frequency Adaptive Meshing')
				$end 'StartInfo'
				$begin 'TotalInfo'
					I(0, ' ')
				$end 'TotalInfo'
				GroupOptions=0
				TaskDataOptions('CPU Time'=8, Memory=8, 'Real Time'=8)
				ProfileItem('Adaptive Refine', 0, 0, 0, 0, 31648, 'I(2, 2, \'Tetrahedra\', 8467, false, 2, \'Cores\', 1, false)', true, true)
				ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Solving Distributed - up to 2 frequencies in parallel\')', false, true)
				ProfileItem(' ', 0, 0, 0, 0, 0, 'I(1, 0, \'\')', false, true)
				$begin 'ProfileGroup'
					MajorVer=2024
					MinorVer=2
					Name='Frequency - 21GHz'
					$begin 'StartInfo'
						I(0, 'DESKTOP-SB5LH8U')
					$end 'StartInfo'
					$begin 'TotalInfo'
						I(0, 'Elapsed time : 00:00:01')
					$end 'TotalInfo'
					GroupOptions=0
					TaskDataOptions('CPU Time'=8, 'Real Time'=8)
					ProfileItem(' ', 0, 0, 0, 0, 0, 'I(1, 0, \'\')', false, true)
					ProfileItem('Simulation Setup ', 0, 0, 0, 0, 226440, 'I(2, 2, \'Tetrahedra\', 8320, false, 1, \'Disk\', \'3.4 KB\')', true, false)
					ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Port 1 supports an additional propagating and/or slowly decaying mode whose attenuation is   3.039e-01 and propagation constant is   6.309e+02\')', false, true)
					ProfileItem('Matrix Assembly', 0, 0, 0, 0, 265488, 'I(3, 2, \'Tetrahedra\', 8320, false, 2, \'1 Triangles\', 93, false, 1, \'Disk\', \'75 Bytes\')', true, false)
					ProfileItem('Matrix Solve', 0, 0, 0, 0, 453584, 'I(5, 1, \'Type\', \'DCS\', 2, \'Cores\', 2, false, 2, \'Matrix size\', 49945, false, 3, \'Matrix bandwidth\', 19.6181, \'%5.1f\', 1, \'Disk\', \'46.1 KB\')', true, false)
					ProfileItem('Field Recovery', 0, 0, 0, 0, 453584, 'I(2, 2, \'Excitations\', 1, false, 1, \'Disk\', \'2.54 MB\')', true, false)
				$end 'ProfileGroup'
				$begin 'ProfileGroup'
					MajorVer=2024
					MinorVer=2
					Name='Frequency - 8GHz'
					$begin 'StartInfo'
						I(0, 'DESKTOP-SB5LH8U')
					$end 'StartInfo'
					$begin 'TotalInfo'
						I(0, 'Elapsed time : 00:00:01')
					$end 'TotalInfo'
					GroupOptions=0
					TaskDataOptions('CPU Time'=8, 'Real Time'=8)
					ProfileItem('Simulation Setup ', 0, 0, 0, 0, 225824, 'I(2, 2, \'Tetrahedra\', 8320, false, 1, \'Disk\', \'3.4 KB\')', true, false)
					ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Port 1 supports an additional propagating and/or slowly decaying mode whose attenuation is   1.514e-01 and propagation constant is   1.838e+02\')', false, true)
					ProfileItem('Matrix Assembly', 0, 0, 0, 0, 263716, 'I(3, 2, \'Tetrahedra\', 8320, false, 2, \'1 Triangles\', 93, false, 1, \'Disk\', \'75 Bytes\')', true, false)
					ProfileItem('Matrix Solve', 0, 0, 0, 0, 453916, 'I(5, 1, \'Type\', \'DCS\', 2, \'Cores\', 2, false, 2, \'Matrix size\', 49945, false, 3, \'Matrix bandwidth\', 19.6181, \'%5.1f\', 1, \'Disk\', \'46.1 KB\')', true, false)
					ProfileItem('Field Recovery', 0, 0, 0, 0, 453916, 'I(2, 2, \'Excitations\', 1, false, 1, \'Disk\', \'2.54 MB\')', true, false)
				$end 'ProfileGroup'
				ProfileItem('Data Transfer', 0, 0, 0, 0, 177236, 'I(1, 0, \'Adaptive Pass 4\')', true, true)
				ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 3, \'Max Mag. Delta S\', 0.0485329, \'%.5f\')', false, true)
			$end 'ProfileGroup'
			ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'\')', false, true)
			$begin 'ProfileGroup'
				MajorVer=2024
				MinorVer=2
				Name='Adaptive Pass 5'
				$begin 'StartInfo'
					I(0, 'Multi-Frequency Adaptive Meshing')
				$end 'StartInfo'
				$begin 'TotalInfo'
					I(0, ' ')
				$end 'TotalInfo'
				GroupOptions=0
				TaskDataOptions('CPU Time'=8, Memory=8, 'Real Time'=8)
				ProfileItem('Adaptive Refine', 0, 0, 0, 0, 34664, 'I(2, 2, \'Tetrahedra\', 10967, false, 2, \'Cores\', 1, false)', true, true)
				ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Solving Distributed - up to 2 frequencies in parallel\')', false, true)
				ProfileItem(' ', 0, 0, 0, 0, 0, 'I(1, 0, \'\')', false, true)
				$begin 'ProfileGroup'
					MajorVer=2024
					MinorVer=2
					Name='Frequency - 21GHz'
					$begin 'StartInfo'
						I(0, 'DESKTOP-SB5LH8U')
					$end 'StartInfo'
					$begin 'TotalInfo'
						I(0, 'Elapsed time : 00:00:02')
					$end 'TotalInfo'
					GroupOptions=0
					TaskDataOptions('CPU Time'=8, 'Real Time'=8)
					ProfileItem(' ', 0, 0, 0, 0, 0, 'I(1, 0, \'\')', false, true)
					ProfileItem('Simulation Setup ', 0, 0, 0, 0, 228412, 'I(2, 2, \'Tetrahedra\', 10820, false, 1, \'Disk\', \'3.4 KB\')', true, false)
					ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Port 1 supports an additional propagating and/or slowly decaying mode whose attenuation is   3.039e-01 and propagation constant is   6.309e+02\')', false, true)
					ProfileItem('Matrix Assembly', 0, 0, 0, 0, 280460, 'I(3, 2, \'Tetrahedra\', 10820, false, 2, \'1 Triangles\', 93, false, 1, \'Disk\', \'0 Bytes\')', true, false)
					ProfileItem('Matrix Solve', 0, 0, 1, 0, 532340, 'I(5, 1, \'Type\', \'DCS\', 2, \'Cores\', 2, false, 2, \'Matrix size\', 65009, false, 3, \'Matrix bandwidth\', 19.9075, \'%5.1f\', 1, \'Disk\', \'60 KB\')', true, false)
					ProfileItem('Field Recovery', 0, 0, 0, 0, 532340, 'I(2, 2, \'Excitations\', 1, false, 1, \'Disk\', \'3.26 MB\')', true, false)
				$end 'ProfileGroup'
				$begin 'ProfileGroup'
					MajorVer=2024
					MinorVer=2
					Name='Frequency - 8GHz'
					$begin 'StartInfo'
						I(0, 'DESKTOP-SB5LH8U')
					$end 'StartInfo'
					$begin 'TotalInfo'
						I(0, 'Elapsed time : 00:00:02')
					$end 'TotalInfo'
					GroupOptions=0
					TaskDataOptions('CPU Time'=8, 'Real Time'=8)
					ProfileItem('Simulation Setup ', 0, 0, 0, 0, 228960, 'I(2, 2, \'Tetrahedra\', 10820, false, 1, \'Disk\', \'3.4 KB\')', true, false)
					ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Port 1 supports an additional propagating and/or slowly decaying mode whose attenuation is   1.514e-01 and propagation constant is   1.838e+02\')', false, true)
					ProfileItem('Matrix Assembly', 0, 0, 0, 0, 280988, 'I(3, 2, \'Tetrahedra\', 10820, false, 2, \'1 Triangles\', 93, false, 1, \'Disk\', \'0 Bytes\')', true, false)
					ProfileItem('Matrix Solve', 0, 0, 1, 0, 531680, 'I(5, 1, \'Type\', \'DCS\', 2, \'Cores\', 2, false, 2, \'Matrix size\', 65009, false, 3, \'Matrix bandwidth\', 19.9075, \'%5.1f\', 1, \'Disk\', \'60 KB\')', true, false)
					ProfileItem('Field Recovery', 0, 0, 0, 0, 531680, 'I(2, 2, \'Excitations\', 1, false, 1, \'Disk\', \'3.26 MB\')', true, false)
				$end 'ProfileGroup'
				ProfileItem('Data Transfer', 0, 0, 0, 0, 177148, 'I(1, 0, \'Adaptive Pass 5\')', true, true)
				ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 3, \'Max Mag. Delta S\', 0.0617363, \'%.5f\')', false, true)
			$end 'ProfileGroup'
			ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'\')', false, true)
			$begin 'ProfileGroup'
				MajorVer=2024
				MinorVer=2
				Name='Adaptive Pass 6'
				$begin 'StartInfo'
					I(0, 'Multi-Frequency Adaptive Meshing')
				$end 'StartInfo'
				$begin 'TotalInfo'
					I(0, ' ')
				$end 'TotalInfo'
				GroupOptions=0
				TaskDataOptions('CPU Time'=8, Memory=8, 'Real Time'=8)
				ProfileItem('Adaptive Refine', 0, 0, 0, 0, 37836, 'I(2, 2, \'Tetrahedra\', 14221, false, 2, \'Cores\', 1, false)', true, true)
				ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Solving Distributed - up to 2 frequencies in parallel\')', false, true)
				ProfileItem(' ', 0, 0, 0, 0, 0, 'I(1, 0, \'\')', false, true)
				$begin 'ProfileGroup'
					MajorVer=2024
					MinorVer=2
					Name='Frequency - 21GHz'
					$begin 'StartInfo'
						I(0, 'DESKTOP-SB5LH8U')
					$end 'StartInfo'
					$begin 'TotalInfo'
						I(0, 'Elapsed time : 00:00:02')
					$end 'TotalInfo'
					GroupOptions=0
					TaskDataOptions('CPU Time'=8, 'Real Time'=8)
					ProfileItem(' ', 0, 0, 0, 0, 0, 'I(1, 0, \'\')', false, true)
					ProfileItem('Simulation Setup ', 0, 0, 0, 0, 236276, 'I(2, 2, \'Tetrahedra\', 14069, false, 1, \'Disk\', \'3.78 KB\')', true, false)
					ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Port 1 supports an additional propagating and/or slowly decaying mode whose attenuation is   3.039e-01 and propagation constant is   6.309e+02\')', false, true)
					ProfileItem('Matrix Assembly', 0, 0, 0, 0, 302868, 'I(3, 2, \'Tetrahedra\', 14069, false, 2, \'1 Triangles\', 97, false, 1, \'Disk\', \'270 Bytes\')', true, false)
					ProfileItem('Matrix Solve', 1, 0, 2, 0, 637548, 'I(5, 1, \'Type\', \'DCS\', 2, \'Cores\', 2, false, 2, \'Matrix size\', 84813, false, 3, \'Matrix bandwidth\', 20.1983, \'%5.1f\', 1, \'Disk\', \'78.5 KB\')', true, false)
					ProfileItem('Field Recovery', 0, 0, 0, 0, 637548, 'I(2, 2, \'Excitations\', 1, false, 1, \'Disk\', \'4.19 MB\')', true, false)
				$end 'ProfileGroup'
				$begin 'ProfileGroup'
					MajorVer=2024
					MinorVer=2
					Name='Frequency - 8GHz'
					$begin 'StartInfo'
						I(0, 'DESKTOP-SB5LH8U')
					$end 'StartInfo'
					$begin 'TotalInfo'
						I(0, 'Elapsed time : 00:00:02')
					$end 'TotalInfo'
					GroupOptions=0
					TaskDataOptions('CPU Time'=8, 'Real Time'=8)
					ProfileItem('Simulation Setup ', 0, 0, 0, 0, 236132, 'I(2, 2, \'Tetrahedra\', 14069, false, 1, \'Disk\', \'3.78 KB\')', true, false)
					ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Port 1 supports an additional propagating and/or slowly decaying mode whose attenuation is   1.514e-01 and propagation constant is   1.838e+02\')', false, true)
					ProfileItem('Matrix Assembly', 0, 0, 0, 0, 304072, 'I(3, 2, \'Tetrahedra\', 14069, false, 2, \'1 Triangles\', 97, false, 1, \'Disk\', \'271 Bytes\')', true, false)
					ProfileItem('Matrix Solve', 1, 0, 2, 0, 637904, 'I(5, 1, \'Type\', \'DCS\', 2, \'Cores\', 2, false, 2, \'Matrix size\', 84813, false, 3, \'Matrix bandwidth\', 20.1983, \'%5.1f\', 1, \'Disk\', \'78.5 KB\')', true, false)
					ProfileItem('Field Recovery', 0, 0, 0, 0, 637904, 'I(2, 2, \'Excitations\', 1, false, 1, \'Disk\', \'4.19 MB\')', true, false)
				$end 'ProfileGroup'
				ProfileItem('Data Transfer', 0, 0, 0, 0, 177068, 'I(1, 0, \'Adaptive Pass 6\')', true, true)
				ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 3, \'Max Mag. Delta S\', 0.0255116, \'%.5f\')', false, true)
			$end 'ProfileGroup'
			ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'\')', false, true)
			$begin 'ProfileGroup'
				MajorVer=2024
				MinorVer=2
				Name='Adaptive Pass 7'
				$begin 'StartInfo'
					I(0, 'Multi-Frequency Adaptive Meshing')
				$end 'StartInfo'
				$begin 'TotalInfo'
					I(0, ' ')
				$end 'TotalInfo'
				GroupOptions=0
				TaskDataOptions('CPU Time'=8, Memory=8, 'Real Time'=8)
				ProfileItem('Adaptive Refine', 0, 0, 0, 0, 42484, 'I(2, 2, \'Tetrahedra\', 18446, false, 2, \'Cores\', 1, false)', true, true)
				ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Solving Distributed - up to 2 frequencies in parallel\')', false, true)
				ProfileItem(' ', 0, 0, 0, 0, 0, 'I(1, 0, \'\')', false, true)
				$begin 'ProfileGroup'
					MajorVer=2024
					MinorVer=2
					Name='Frequency - 21GHz'
					$begin 'StartInfo'
						I(0, 'DESKTOP-SB5LH8U')
					$end 'StartInfo'
					$begin 'TotalInfo'
						I(0, 'Elapsed time : 00:00:03')
					$end 'TotalInfo'
					GroupOptions=0
					TaskDataOptions('CPU Time'=8, 'Real Time'=8)
					ProfileItem(' ', 0, 0, 0, 0, 0, 'I(1, 0, \'\')', false, true)
					ProfileItem('Simulation Setup ', 0, 0, 0, 0, 246068, 'I(2, 2, \'Tetrahedra\', 18292, false, 1, \'Disk\', \'5.94 KB\')', true, false)
					ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Port 1 supports an additional propagating and/or slowly decaying mode whose attenuation is   3.039e-01 and propagation constant is   6.309e+02\')', false, true)
					ProfileItem('Matrix Assembly', 0, 0, 0, 0, 333472, 'I(3, 2, \'Tetrahedra\', 18292, false, 2, \'1 Triangles\', 99, false, 1, \'Disk\', \'65 Bytes\')', true, false)
					ProfileItem('Matrix Solve', 2, 0, 3, 0, 830760, 'I(5, 1, \'Type\', \'DCS\', 2, \'Cores\', 2, false, 2, \'Matrix size\', 110715, false, 3, \'Matrix bandwidth\', 20.4465, \'%5.1f\', 1, \'Disk\', \'102 KB\')', true, false)
					ProfileItem('Field Recovery', 0, 0, 0, 0, 830760, 'I(2, 2, \'Excitations\', 1, false, 1, \'Disk\', \'5.4 MB\')', true, false)
				$end 'ProfileGroup'
				$begin 'ProfileGroup'
					MajorVer=2024
					MinorVer=2
					Name='Frequency - 8GHz'
					$begin 'StartInfo'
						I(0, 'DESKTOP-SB5LH8U')
					$end 'StartInfo'
					$begin 'TotalInfo'
						I(0, 'Elapsed time : 00:00:04')
					$end 'TotalInfo'
					GroupOptions=0
					TaskDataOptions('CPU Time'=8, 'Real Time'=8)
					ProfileItem('Simulation Setup ', 0, 0, 0, 0, 244540, 'I(2, 2, \'Tetrahedra\', 18292, false, 1, \'Disk\', \'5.94 KB\')', true, false)
					ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Port 1 supports an additional propagating and/or slowly decaying mode whose attenuation is   1.514e-01 and propagation constant is   1.838e+02\')', false, true)
					ProfileItem('Matrix Assembly', 0, 0, 0, 0, 331088, 'I(3, 2, \'Tetrahedra\', 18292, false, 2, \'1 Triangles\', 99, false, 1, \'Disk\', \'66 Bytes\')', true, false)
					ProfileItem('Matrix Solve', 2, 0, 4, 0, 827844, 'I(5, 1, \'Type\', \'DCS\', 2, \'Cores\', 2, false, 2, \'Matrix size\', 110715, false, 3, \'Matrix bandwidth\', 20.4465, \'%5.1f\', 1, \'Disk\', \'102 KB\')', true, false)
					ProfileItem('Field Recovery', 0, 0, 0, 0, 827844, 'I(2, 2, \'Excitations\', 1, false, 1, \'Disk\', \'5.4 MB\')', true, false)
				$end 'ProfileGroup'
				ProfileItem('Data Transfer', 0, 0, 0, 0, 177540, 'I(1, 0, \'Adaptive Pass 7\')', true, true)
				ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 3, \'Max Mag. Delta S\', 0.0253497, \'%.5f\')', false, true)
			$end 'ProfileGroup'
			ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'\')', false, true)
			$begin 'ProfileGroup'
				MajorVer=2024
				MinorVer=2
				Name='Adaptive Pass 8'
				$begin 'StartInfo'
					I(0, 'Multi-Frequency Adaptive Meshing')
				$end 'StartInfo'
				$begin 'TotalInfo'
					I(0, ' ')
				$end 'TotalInfo'
				GroupOptions=0
				TaskDataOptions('CPU Time'=8, Memory=8, 'Real Time'=8)
				ProfileItem('Adaptive Refine', 0, 0, 0, 0, 48492, 'I(2, 2, \'Tetrahedra\', 23938, false, 2, \'Cores\', 1, false)', true, true)
				ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Solving Distributed - up to 2 frequencies in parallel\')', false, true)
				ProfileItem(' ', 0, 0, 0, 0, 0, 'I(1, 0, \'\')', false, true)
				$begin 'ProfileGroup'
					MajorVer=2024
					MinorVer=2
					Name='Frequency - 21GHz'
					$begin 'StartInfo'
						I(0, 'DESKTOP-SB5LH8U')
					$end 'StartInfo'
					$begin 'TotalInfo'
						I(0, 'Elapsed time : 00:00:05')
					$end 'TotalInfo'
					GroupOptions=0
					TaskDataOptions('CPU Time'=8, 'Real Time'=8)
					ProfileItem(' ', 0, 0, 0, 0, 0, 'I(1, 0, \'\')', false, true)
					ProfileItem('Simulation Setup ', 0, 0, 0, 0, 257636, 'I(2, 2, \'Tetrahedra\', 23784, false, 1, \'Disk\', \'7.87 KB\')', true, false)
					ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Port 1 supports an additional propagating and/or slowly decaying mode whose attenuation is   3.039e-01 and propagation constant is   6.309e+02\')', false, true)
					ProfileItem('Matrix Assembly', 0, 0, 1, 0, 369728, 'I(3, 2, \'Tetrahedra\', 23784, false, 2, \'1 Triangles\', 99, false, 1, \'Disk\', \'0 Bytes\')', true, false)
					ProfileItem('Matrix Solve', 3, 0, 6, 0, 1016368, 'I(5, 1, \'Type\', \'DCS\', 2, \'Cores\', 2, false, 2, \'Matrix size\', 144473, false, 3, \'Matrix bandwidth\', 20.6456, \'%5.1f\', 1, \'Disk\', \'133 KB\')', true, false)
					ProfileItem('Field Recovery', 0, 0, 0, 0, 1016368, 'I(2, 2, \'Excitations\', 1, false, 1, \'Disk\', \'6.97 MB\')', true, false)
				$end 'ProfileGroup'
				$begin 'ProfileGroup'
					MajorVer=2024
					MinorVer=2
					Name='Frequency - 8GHz'
					$begin 'StartInfo'
						I(0, 'DESKTOP-SB5LH8U')
					$end 'StartInfo'
					$begin 'TotalInfo'
						I(0, 'Elapsed time : 00:00:05')
					$end 'TotalInfo'
					GroupOptions=0
					TaskDataOptions('CPU Time'=8, 'Real Time'=8)
					ProfileItem('Simulation Setup ', 0, 0, 0, 0, 256668, 'I(2, 2, \'Tetrahedra\', 23784, false, 1, \'Disk\', \'7.87 KB\')', true, false)
					ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Port 1 supports an additional propagating and/or slowly decaying mode whose attenuation is   1.514e-01 and propagation constant is   1.838e+02\')', false, true)
					ProfileItem('Matrix Assembly', 0, 0, 1, 0, 368684, 'I(3, 2, \'Tetrahedra\', 23784, false, 2, \'1 Triangles\', 99, false, 1, \'Disk\', \'0 Bytes\')', true, false)
					ProfileItem('Matrix Solve', 4, 0, 7, 0, 1016916, 'I(5, 1, \'Type\', \'DCS\', 2, \'Cores\', 2, false, 2, \'Matrix size\', 144473, false, 3, \'Matrix bandwidth\', 20.6456, \'%5.1f\', 1, \'Disk\', \'133 KB\')', true, false)
					ProfileItem('Field Recovery', 0, 0, 0, 0, 1016916, 'I(2, 2, \'Excitations\', 1, false, 1, \'Disk\', \'6.97 MB\')', true, false)
				$end 'ProfileGroup'
				ProfileItem('Data Transfer', 0, 0, 0, 0, 177316, 'I(1, 0, \'Adaptive Pass 8\')', true, true)
				ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 3, \'Max Mag. Delta S\', 0.0178606, \'%.5f\')', false, true)
			$end 'ProfileGroup'
			ProfileFootnote('I(1, 0, \'Adaptive Passes converged\')', 0)
		$end 'ProfileGroup'
		$begin 'ProfileGroup'
			MajorVer=2024
			MinorVer=2
			Name='Frequency Sweep'
			$begin 'StartInfo'
				I(1, 'Time', '04/18/2026 19:43:54')
			$end 'StartInfo'
			$begin 'TotalInfo'
				I(1, 'Elapsed Time', '00:00:45')
			$end 'TotalInfo'
			GroupOptions=4
			TaskDataOptions('CPU Time'=8, Memory=8, 'Real Time'=8)
			ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 1, \'HPC\', \'Enabled\')', false, true)
			ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'\')', false, true)
			ProfileItem('Solution SParam_Sweep', 0, 0, 0, 0, 0, 'I(1, 0, \'Fast Sweep\')', false, true)
			ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'From 8 GHz to 21 GHz, 200 Steps\')', false, true)
			ProfileItem('Simulation Setup', 0, 0, 0, 0, 222420, 'I(1, 1, \'Disk\', \'0 Bytes\')', true, true)
			ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Port 1 supports an additional propagating and/or slowly decaying mode whose attenuation is   2.185e-01 and propagation constant is   4.185e+02\')', false, true)
			ProfileItem('Matrix Assembly', 1, 0, 1, 0, 425860, 'I(3, 2, \'Tetrahedra\', 23784, false, 2, \'1 Triangles\', 99, false, 1, \'Disk\', \'2 Bytes\')', true, true)
			ProfileItem('Matrix Solve', 43, 0, 50, 0, 1173288, 'I(6, 1, \'Type\', \'DCS\', 2, \'Cores\', 4, false, 2, \'Matrix size\', 144473, false, 3, \'Matrix bandwidth\', 20.6456, \'%5.1f\', 2, \'Reduced matrix size\', 37, false, 1, \'Disk\', \'82.9 MB\')', true, true)
			ProfileItem('Field Recovery', 0, 0, 0, 0, 1173288, 'I(2, 2, \'Excitations\', 1, false, 1, \'Disk\', \'6.23 MB\')', true, true)
		$end 'ProfileGroup'
		ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'\')', false, true)
		$begin 'ProfileGroup'
			MajorVer=2024
			MinorVer=2
			Name='Simulation Summary'
			$begin 'StartInfo'
			$end 'StartInfo'
			$begin 'TotalInfo'
				I(0, ' ')
			$end 'TotalInfo'
			GroupOptions=0
			TaskDataOptions('CPU Time'=8, Memory=8, 'Real Time'=8)
			ProfileItem('Design Validation', 0, 0, 0, 0, 0, 'I(2, 1, \'Elapsed Time\', \'00:00:00\', 1, \'Total Memory\', \'174 MB\')', false, true)
			ProfileItem('Initial Meshing', 0, 0, 0, 0, 0, 'I(2, 1, \'Elapsed Time\', \'00:00:01\', 1, \'Total Memory\', \'227 MB\')', false, true)
			ProfileItem('Adaptive Meshing', 0, 0, 0, 0, 0, 'I(5, 1, \'Elapsed Time\', \'00:00:57\', 1, \'Average memory/process\', \'993 MB\', 1, \'Max memory/process\', \'993 MB\', 2, \'Max number of processes/frequency\', 1, false, 2, \'Total number of cores\', 4, false)', false, true)
			ProfileItem('Frequency Sweep', 0, 0, 0, 0, 0, 'I(2, 1, \'Elapsed Time\', \'00:00:45\', 1, \'Total Memory\', \'1.12 GB\')', false, true)
			ProfileFootnote('I(3, 2, \'Max solved tets\', 23784, false, 2, \'Max matrix size\', 144473, false, 1, \'Matrix bandwidth\', \'20.6\')', 0)
		$end 'ProfileGroup'
		ProfileFootnote('I(2, 1, \'Stop Time\', \'04/18/2026 19:44:40\', 1, \'Status\', \'Normal Completion\')', 0)
	$end 'ProfileGroup'
$end 'Profile'
