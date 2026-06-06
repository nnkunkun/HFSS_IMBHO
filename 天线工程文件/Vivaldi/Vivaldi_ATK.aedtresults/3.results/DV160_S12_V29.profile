$begin 'Profile'
	$begin 'ProfileGroup'
		MajorVer=2024
		MinorVer=2
		Name='Solution Process'
		$begin 'StartInfo'
			I(1, 'Start Time', '04/18/2026 19:39:49')
			I(1, 'Host', 'DESKTOP-SB5LH8U')
			I(1, 'Processor', '32')
			I(1, 'OS', 'NT 10.0')
			I(1, 'Product', 'HFSS Version 2024.2.0')
		$end 'StartInfo'
		$begin 'TotalInfo'
			I(1, 'Elapsed Time', '00:01:32')
			I(1, 'ComEngine Memory', '181 M')
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
		ProfileItem('Design Validation', 0, 0, 0, 0, 0, 'I(1, 0, \'Elapsed time : 00:00:00 , HFSS ComEngine Memory : 175 M\')', false, true)
		ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Perform full validations with standard port validations\')', false, true)
		ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'\')', false, true)
		$begin 'ProfileGroup'
			MajorVer=2024
			MinorVer=2
			Name='Initial Meshing'
			$begin 'StartInfo'
				I(1, 'Time', '04/18/2026 19:39:50')
			$end 'StartInfo'
			$begin 'TotalInfo'
				I(1, 'Elapsed Time', '00:00:01')
			$end 'TotalInfo'
			GroupOptions=4
			TaskDataOptions('CPU Time'=8, Memory=8, 'Real Time'=8)
			ProfileItem('Mesh', 0, 0, 0, 0, 34384, 'I(2, 1, \'Type\', \'Phi\', 2, \'Tetrahedra\', 736, false)', true, true)
			ProfileItem('Post', 0, 0, 0, 0, 36312, 'I(2, 2, \'Tetrahedra\', 736, false, 2, \'Cores\', 1, false)', true, true)
			ProfileItem('Lambda Refine', 0, 0, 0, 0, 31364, 'I(2, 2, \'Tetrahedra\', 3622, false, 2, \'Cores\', 1, false)', true, true)
			ProfileItem('Simulation Setup', 0, 0, 0, 0, 182044, 'I(1, 1, \'Disk\', \'0 Bytes\')', true, true)
			ProfileItem('Port Adapt', 0, 0, 0, 0, 194716, 'I(2, 2, \'Tetrahedra\', 3589, false, 1, \'Disk\', \'5.18 KB\')', true, true)
			ProfileItem('Port Refine', 0, 0, 0, 0, 25368, 'I(2, 2, \'Tetrahedra\', 3893, false, 2, \'Cores\', 1, false)', true, true)
		$end 'ProfileGroup'
		$begin 'ProfileGroup'
			MajorVer=2024
			MinorVer=2
			Name='Adaptive Meshing'
			$begin 'StartInfo'
				I(1, 'Time', '04/18/2026 19:39:51')
			$end 'StartInfo'
			$begin 'TotalInfo'
				I(1, 'Elapsed Time', '00:01:01')
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
					ProfileItem('Simulation Setup ', 0, 0, 0, 0, 211840, 'I(2, 2, \'Tetrahedra\', 3755, false, 1, \'Disk\', \'4.17 KB\')', true, false)
					ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Port 1 supports an additional propagating and/or slowly decaying mode whose attenuation is   3.039e-01 and propagation constant is   6.309e+02\')', false, true)
					ProfileItem('Matrix Assembly', 0, 0, 0, 0, 233156, 'I(3, 2, \'Tetrahedra\', 3755, false, 2, \'1 Triangles\', 81, false, 1, \'Disk\', \'0 Bytes\')', true, false)
					ProfileItem('Matrix Solve', 0, 0, 0, 0, 302464, 'I(5, 1, \'Type\', \'DCS\', 2, \'Cores\', 2, false, 2, \'Matrix size\', 22561, false, 3, \'Matrix bandwidth\', 18.5757, \'%5.1f\', 1, \'Disk\', \'2.22 KB\')', true, false)
					ProfileItem('Field Recovery', 0, 0, 0, 0, 302464, 'I(2, 2, \'Excitations\', 1, false, 1, \'Disk\', \'1.53 MB\')', true, false)
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
					ProfileItem('Simulation Setup ', 0, 0, 0, 0, 211924, 'I(2, 2, \'Tetrahedra\', 3755, false, 1, \'Disk\', \'4.17 KB\')', true, false)
					ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Port 1 supports an additional propagating and/or slowly decaying mode whose attenuation is   1.514e-01 and propagation constant is   1.838e+02\')', false, true)
					ProfileItem('Matrix Assembly', 0, 0, 0, 0, 233540, 'I(3, 2, \'Tetrahedra\', 3755, false, 2, \'1 Triangles\', 81, false, 1, \'Disk\', \'0 Bytes\')', true, false)
					ProfileItem('Matrix Solve', 0, 0, 0, 0, 303396, 'I(5, 1, \'Type\', \'DCS\', 2, \'Cores\', 2, false, 2, \'Matrix size\', 22561, false, 3, \'Matrix bandwidth\', 18.5757, \'%5.1f\', 1, \'Disk\', \'2.22 KB\')', true, false)
					ProfileItem('Field Recovery', 0, 0, 0, 0, 303396, 'I(2, 2, \'Excitations\', 1, false, 1, \'Disk\', \'1.53 MB\')', true, false)
				$end 'ProfileGroup'
				ProfileItem('Data Transfer', 0, 0, 0, 0, 179784, 'I(1, 0, \'Adaptive Pass 1\')', true, true)
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
				ProfileItem('Adaptive Refine', 0, 0, 0, 0, 28372, 'I(2, 2, \'Tetrahedra\', 5022, false, 2, \'Cores\', 1, false)', true, true)
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
					ProfileItem('Simulation Setup ', 0, 0, 0, 0, 215140, 'I(2, 2, \'Tetrahedra\', 4884, false, 1, \'Disk\', \'4.17 KB\')', true, false)
					ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Port 1 supports an additional propagating and/or slowly decaying mode whose attenuation is   3.039e-01 and propagation constant is   6.309e+02\')', false, true)
					ProfileItem('Matrix Assembly', 0, 0, 0, 0, 242068, 'I(3, 2, \'Tetrahedra\', 4884, false, 2, \'1 Triangles\', 81, false, 1, \'Disk\', \'6 Bytes\')', true, false)
					ProfileItem('Matrix Solve', 0, 0, 0, 0, 339160, 'I(5, 1, \'Type\', \'DCS\', 2, \'Cores\', 2, false, 2, \'Matrix size\', 29075, false, 3, \'Matrix bandwidth\', 18.7992, \'%5.1f\', 1, \'Disk\', \'26.6 KB\')', true, false)
					ProfileItem('Field Recovery', 0, 0, 0, 0, 339160, 'I(2, 2, \'Excitations\', 1, false, 1, \'Disk\', \'1.55 MB\')', true, false)
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
					ProfileItem('Simulation Setup ', 0, 0, 0, 0, 214676, 'I(2, 2, \'Tetrahedra\', 4884, false, 1, \'Disk\', \'4.17 KB\')', true, false)
					ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Port 1 supports an additional propagating and/or slowly decaying mode whose attenuation is   1.514e-01 and propagation constant is   1.838e+02\')', false, true)
					ProfileItem('Matrix Assembly', 0, 0, 0, 0, 241420, 'I(3, 2, \'Tetrahedra\', 4884, false, 2, \'1 Triangles\', 81, false, 1, \'Disk\', \'6 Bytes\')', true, false)
					ProfileItem('Matrix Solve', 0, 0, 0, 0, 336268, 'I(5, 1, \'Type\', \'DCS\', 2, \'Cores\', 2, false, 2, \'Matrix size\', 29075, false, 3, \'Matrix bandwidth\', 18.7992, \'%5.1f\', 1, \'Disk\', \'26.6 KB\')', true, false)
					ProfileItem('Field Recovery', 0, 0, 0, 0, 336268, 'I(2, 2, \'Excitations\', 1, false, 1, \'Disk\', \'1.55 MB\')', true, false)
				$end 'ProfileGroup'
				ProfileItem('Data Transfer', 0, 0, 0, 0, 180020, 'I(1, 0, \'Adaptive Pass 2\')', true, true)
				ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 3, \'Max Mag. Delta S\', 1.27912, \'%.5f\')', false, true)
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
				ProfileItem('Adaptive Refine', 0, 0, 0, 0, 29448, 'I(2, 2, \'Tetrahedra\', 6492, false, 2, \'Cores\', 1, false)', true, true)
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
					ProfileItem('Simulation Setup ', 0, 0, 0, 0, 222352, 'I(2, 2, \'Tetrahedra\', 6354, false, 1, \'Disk\', \'3.02 KB\')', true, false)
					ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Port 1 supports an additional propagating and/or slowly decaying mode whose attenuation is   3.039e-01 and propagation constant is   6.309e+02\')', false, true)
					ProfileItem('Matrix Assembly', 0, 0, 0, 0, 251468, 'I(3, 2, \'Tetrahedra\', 6354, false, 2, \'1 Triangles\', 81, false, 1, \'Disk\', \'12 Bytes\')', true, false)
					ProfileItem('Matrix Solve', 0, 0, 0, 0, 385364, 'I(5, 1, \'Type\', \'DCS\', 2, \'Cores\', 2, false, 2, \'Matrix size\', 37791, false, 3, \'Matrix bandwidth\', 19.1599, \'%5.1f\', 1, \'Disk\', \'35.2 KB\')', true, false)
					ProfileItem('Field Recovery', 0, 0, 0, 0, 385364, 'I(2, 2, \'Excitations\', 1, false, 1, \'Disk\', \'1.97 MB\')', true, false)
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
					ProfileItem('Simulation Setup ', 0, 0, 0, 0, 222544, 'I(2, 2, \'Tetrahedra\', 6354, false, 1, \'Disk\', \'3.02 KB\')', true, false)
					ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Port 1 supports an additional propagating and/or slowly decaying mode whose attenuation is   1.514e-01 and propagation constant is   1.838e+02\')', false, true)
					ProfileItem('Matrix Assembly', 0, 0, 0, 0, 251928, 'I(3, 2, \'Tetrahedra\', 6354, false, 2, \'1 Triangles\', 81, false, 1, \'Disk\', \'12 Bytes\')', true, false)
					ProfileItem('Matrix Solve', 0, 0, 0, 0, 388136, 'I(5, 1, \'Type\', \'DCS\', 2, \'Cores\', 2, false, 2, \'Matrix size\', 37791, false, 3, \'Matrix bandwidth\', 19.1599, \'%5.1f\', 1, \'Disk\', \'35.2 KB\')', true, false)
					ProfileItem('Field Recovery', 0, 0, 0, 0, 388136, 'I(2, 2, \'Excitations\', 1, false, 1, \'Disk\', \'1.97 MB\')', true, false)
				$end 'ProfileGroup'
				ProfileItem('Data Transfer', 0, 0, 0, 0, 178284, 'I(1, 0, \'Adaptive Pass 3\')', true, true)
				ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 3, \'Max Mag. Delta S\', 0.306413, \'%.5f\')', false, true)
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
				ProfileItem('Adaptive Refine', 0, 0, 0, 0, 31676, 'I(2, 2, \'Tetrahedra\', 8399, false, 2, \'Cores\', 1, false)', true, true)
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
					ProfileItem('Simulation Setup ', 0, 0, 0, 0, 221940, 'I(2, 2, \'Tetrahedra\', 8263, false, 1, \'Disk\', \'3.02 KB\')', true, false)
					ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Port 1 supports an additional propagating and/or slowly decaying mode whose attenuation is   3.039e-01 and propagation constant is   6.309e+02\')', false, true)
					ProfileItem('Matrix Assembly', 0, 0, 0, 0, 262420, 'I(3, 2, \'Tetrahedra\', 8263, false, 2, \'1 Triangles\', 81, false, 1, \'Disk\', \'4 Bytes\')', true, false)
					ProfileItem('Matrix Solve', 0, 0, 0, 0, 438264, 'I(5, 1, \'Type\', \'DCS\', 2, \'Cores\', 2, false, 2, \'Matrix size\', 49183, false, 3, \'Matrix bandwidth\', 19.5072, \'%5.1f\', 1, \'Disk\', \'45.7 KB\')', true, false)
					ProfileItem('Field Recovery', 0, 0, 0, 0, 438264, 'I(2, 2, \'Excitations\', 1, false, 1, \'Disk\', \'2.51 MB\')', true, false)
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
					ProfileItem('Simulation Setup ', 0, 0, 0, 0, 222508, 'I(2, 2, \'Tetrahedra\', 8263, false, 1, \'Disk\', \'3.02 KB\')', true, false)
					ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Port 1 supports an additional propagating and/or slowly decaying mode whose attenuation is   1.514e-01 and propagation constant is   1.838e+02\')', false, true)
					ProfileItem('Matrix Assembly', 0, 0, 0, 0, 263172, 'I(3, 2, \'Tetrahedra\', 8263, false, 2, \'1 Triangles\', 81, false, 1, \'Disk\', \'4 Bytes\')', true, false)
					ProfileItem('Matrix Solve', 0, 0, 0, 0, 438800, 'I(5, 1, \'Type\', \'DCS\', 2, \'Cores\', 2, false, 2, \'Matrix size\', 49183, false, 3, \'Matrix bandwidth\', 19.5072, \'%5.1f\', 1, \'Disk\', \'45.7 KB\')', true, false)
					ProfileItem('Field Recovery', 0, 0, 0, 0, 438800, 'I(2, 2, \'Excitations\', 1, false, 1, \'Disk\', \'2.51 MB\')', true, false)
				$end 'ProfileGroup'
				ProfileItem('Data Transfer', 0, 0, 0, 0, 177796, 'I(1, 0, \'Adaptive Pass 4\')', true, true)
				ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 3, \'Max Mag. Delta S\', 0.067296, \'%.5f\')', false, true)
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
				ProfileItem('Adaptive Refine', 0, 0, 0, 0, 34492, 'I(2, 2, \'Tetrahedra\', 10883, false, 2, \'Cores\', 1, false)', true, true)
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
					ProfileItem('Simulation Setup ', 0, 0, 0, 0, 228412, 'I(2, 2, \'Tetrahedra\', 10747, false, 1, \'Disk\', \'3.02 KB\')', true, false)
					ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Port 1 supports an additional propagating and/or slowly decaying mode whose attenuation is   3.039e-01 and propagation constant is   6.309e+02\')', false, true)
					ProfileItem('Matrix Assembly', 0, 0, 0, 0, 279536, 'I(3, 2, \'Tetrahedra\', 10747, false, 2, \'1 Triangles\', 81, false, 1, \'Disk\', \'450 Bytes\')', true, false)
					ProfileItem('Matrix Solve', 0, 0, 1, 0, 518288, 'I(5, 1, \'Type\', \'DCS\', 2, \'Cores\', 2, false, 2, \'Matrix size\', 64117, false, 3, \'Matrix bandwidth\', 19.8031, \'%5.1f\', 1, \'Disk\', \'59.5 KB\')', true, false)
					ProfileItem('Field Recovery', 0, 0, 0, 0, 518288, 'I(2, 2, \'Excitations\', 1, false, 1, \'Disk\', \'3.22 MB\')', true, false)
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
					ProfileItem('Simulation Setup ', 0, 0, 0, 0, 228204, 'I(2, 2, \'Tetrahedra\', 10747, false, 1, \'Disk\', \'3.02 KB\')', true, false)
					ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Port 1 supports an additional propagating and/or slowly decaying mode whose attenuation is   1.514e-01 and propagation constant is   1.838e+02\')', false, true)
					ProfileItem('Matrix Assembly', 0, 0, 0, 0, 279336, 'I(3, 2, \'Tetrahedra\', 10747, false, 2, \'1 Triangles\', 81, false, 1, \'Disk\', \'450 Bytes\')', true, false)
					ProfileItem('Matrix Solve', 0, 0, 1, 0, 518404, 'I(5, 1, \'Type\', \'DCS\', 2, \'Cores\', 2, false, 2, \'Matrix size\', 64117, false, 3, \'Matrix bandwidth\', 19.8031, \'%5.1f\', 1, \'Disk\', \'59.5 KB\')', true, false)
					ProfileItem('Field Recovery', 0, 0, 0, 0, 518404, 'I(2, 2, \'Excitations\', 1, false, 1, \'Disk\', \'3.22 MB\')', true, false)
				$end 'ProfileGroup'
				ProfileItem('Data Transfer', 0, 0, 0, 0, 177864, 'I(1, 0, \'Adaptive Pass 5\')', true, true)
				ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 3, \'Max Mag. Delta S\', 0.0303914, \'%.5f\')', false, true)
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
				ProfileItem('Adaptive Refine', 0, 0, 0, 0, 37804, 'I(2, 2, \'Tetrahedra\', 14109, false, 2, \'Cores\', 1, false)', true, true)
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
					ProfileItem('Simulation Setup ', 0, 0, 0, 0, 240156, 'I(2, 2, \'Tetrahedra\', 13973, false, 1, \'Disk\', \'2.79 KB\')', true, false)
					ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Port 1 supports an additional propagating and/or slowly decaying mode whose attenuation is   3.039e-01 and propagation constant is   6.309e+02\')', false, true)
					ProfileItem('Matrix Assembly', 0, 0, 0, 0, 303320, 'I(3, 2, \'Tetrahedra\', 13973, false, 2, \'1 Triangles\', 81, false, 1, \'Disk\', \'0 Bytes\')', true, false)
					ProfileItem('Matrix Solve', 1, 0, 1, 0, 637104, 'I(5, 1, \'Type\', \'DCS\', 2, \'Cores\', 2, false, 2, \'Matrix size\', 83837, false, 3, \'Matrix bandwidth\', 20.1127, \'%5.1f\', 1, \'Disk\', \'78.2 KB\')', true, false)
					ProfileItem('Field Recovery', 0, 0, 0, 0, 637104, 'I(2, 2, \'Excitations\', 1, false, 1, \'Disk\', \'4.15 MB\')', true, false)
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
					ProfileItem('Simulation Setup ', 0, 0, 0, 0, 239644, 'I(2, 2, \'Tetrahedra\', 13973, false, 1, \'Disk\', \'2.79 KB\')', true, false)
					ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Port 1 supports an additional propagating and/or slowly decaying mode whose attenuation is   1.514e-01 and propagation constant is   1.838e+02\')', false, true)
					ProfileItem('Matrix Assembly', 0, 0, 0, 0, 302516, 'I(3, 2, \'Tetrahedra\', 13973, false, 2, \'1 Triangles\', 81, false, 1, \'Disk\', \'0 Bytes\')', true, false)
					ProfileItem('Matrix Solve', 1, 0, 1, 0, 638348, 'I(5, 1, \'Type\', \'DCS\', 2, \'Cores\', 2, false, 2, \'Matrix size\', 83837, false, 3, \'Matrix bandwidth\', 20.1127, \'%5.1f\', 1, \'Disk\', \'78.2 KB\')', true, false)
					ProfileItem('Field Recovery', 0, 0, 0, 0, 638348, 'I(2, 2, \'Excitations\', 1, false, 1, \'Disk\', \'4.15 MB\')', true, false)
				$end 'ProfileGroup'
				ProfileItem('Data Transfer', 0, 0, 0, 0, 178452, 'I(1, 0, \'Adaptive Pass 6\')', true, true)
				ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 3, \'Max Mag. Delta S\', 0.0460965, \'%.5f\')', false, true)
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
				ProfileItem('Adaptive Refine', 0, 0, 0, 0, 42436, 'I(2, 2, \'Tetrahedra\', 18303, false, 2, \'Cores\', 1, false)', true, true)
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
					ProfileItem('Simulation Setup ', 0, 0, 0, 0, 245244, 'I(2, 2, \'Tetrahedra\', 18166, false, 1, \'Disk\', \'5.33 KB\')', true, false)
					ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Port 1 supports an additional propagating and/or slowly decaying mode whose attenuation is   3.039e-01 and propagation constant is   6.309e+02\')', false, true)
					ProfileItem('Matrix Assembly', 0, 0, 0, 0, 331056, 'I(3, 2, \'Tetrahedra\', 18166, false, 2, \'1 Triangles\', 82, false, 1, \'Disk\', \'71 Bytes\')', true, false)
					ProfileItem('Matrix Solve', 1, 0, 2, 0, 792764, 'I(5, 1, \'Type\', \'DCS\', 2, \'Cores\', 2, false, 2, \'Matrix size\', 109489, false, 3, \'Matrix bandwidth\', 20.3664, \'%5.1f\', 1, \'Disk\', \'101 KB\')', true, false)
					ProfileItem('Field Recovery', 0, 0, 0, 0, 792764, 'I(2, 2, \'Excitations\', 1, false, 1, \'Disk\', \'5.35 MB\')', true, false)
				$end 'ProfileGroup'
				$begin 'ProfileGroup'
					MajorVer=2024
					MinorVer=2
					Name='Frequency - 8GHz'
					$begin 'StartInfo'
						I(0, 'DESKTOP-SB5LH8U')
					$end 'StartInfo'
					$begin 'TotalInfo'
						I(0, 'Elapsed time : 00:00:03')
					$end 'TotalInfo'
					GroupOptions=0
					TaskDataOptions('CPU Time'=8, 'Real Time'=8)
					ProfileItem('Simulation Setup ', 0, 0, 0, 0, 244208, 'I(2, 2, \'Tetrahedra\', 18166, false, 1, \'Disk\', \'5.33 KB\')', true, false)
					ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Port 1 supports an additional propagating and/or slowly decaying mode whose attenuation is   1.514e-01 and propagation constant is   1.838e+02\')', false, true)
					ProfileItem('Matrix Assembly', 0, 0, 0, 0, 329284, 'I(3, 2, \'Tetrahedra\', 18166, false, 2, \'1 Triangles\', 82, false, 1, \'Disk\', \'71 Bytes\')', true, false)
					ProfileItem('Matrix Solve', 2, 0, 3, 0, 793408, 'I(5, 1, \'Type\', \'DCS\', 2, \'Cores\', 2, false, 2, \'Matrix size\', 109489, false, 3, \'Matrix bandwidth\', 20.3664, \'%5.1f\', 1, \'Disk\', \'101 KB\')', true, false)
					ProfileItem('Field Recovery', 0, 0, 0, 0, 793408, 'I(2, 2, \'Excitations\', 1, false, 1, \'Disk\', \'5.35 MB\')', true, false)
				$end 'ProfileGroup'
				ProfileItem('Data Transfer', 0, 0, 0, 0, 178740, 'I(1, 0, \'Adaptive Pass 7\')', true, true)
				ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 3, \'Max Mag. Delta S\', 0.00836372, \'%.5f\')', false, true)
			$end 'ProfileGroup'
			ProfileFootnote('I(1, 0, \'Adaptive Passes converged\')', 0)
		$end 'ProfileGroup'
		$begin 'ProfileGroup'
			MajorVer=2024
			MinorVer=2
			Name='Frequency Sweep'
			$begin 'StartInfo'
				I(1, 'Time', '04/18/2026 19:40:53')
			$end 'StartInfo'
			$begin 'TotalInfo'
				I(1, 'Elapsed Time', '00:00:29')
			$end 'TotalInfo'
			GroupOptions=4
			TaskDataOptions('CPU Time'=8, Memory=8, 'Real Time'=8)
			ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 1, \'HPC\', \'Enabled\')', false, true)
			ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'\')', false, true)
			ProfileItem('Solution SParam_Sweep', 0, 0, 0, 0, 0, 'I(1, 0, \'Fast Sweep\')', false, true)
			ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'From 8 GHz to 21 GHz, 200 Steps\')', false, true)
			ProfileItem('Simulation Setup', 0, 0, 0, 0, 210764, 'I(1, 1, \'Disk\', \'0 Bytes\')', true, true)
			ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Port 1 supports an additional propagating and/or slowly decaying mode whose attenuation is   2.185e-01 and propagation constant is   4.185e+02\')', false, true)
			ProfileItem('Matrix Assembly', 0, 0, 0, 0, 364704, 'I(3, 2, \'Tetrahedra\', 18166, false, 2, \'1 Triangles\', 82, false, 1, \'Disk\', \'0 Bytes\')', true, true)
			ProfileItem('Matrix Solve', 28, 0, 31, 0, 878240, 'I(6, 1, \'Type\', \'DCS\', 2, \'Cores\', 4, false, 2, \'Matrix size\', 109489, false, 3, \'Matrix bandwidth\', 20.3664, \'%5.1f\', 2, \'Reduced matrix size\', 30, false, 1, \'Disk\', \'51 MB\')', true, true)
			ProfileItem('Field Recovery', 0, 0, 0, 0, 878240, 'I(2, 2, \'Excitations\', 1, false, 1, \'Disk\', \'4.78 MB\')', true, true)
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
			ProfileItem('Design Validation', 0, 0, 0, 0, 0, 'I(2, 1, \'Elapsed Time\', \'00:00:00\', 1, \'Total Memory\', \'175 MB\')', false, true)
			ProfileItem('Initial Meshing', 0, 0, 0, 0, 0, 'I(2, 1, \'Elapsed Time\', \'00:00:01\', 1, \'Total Memory\', \'226 MB\')', false, true)
			ProfileItem('Adaptive Meshing', 0, 0, 0, 0, 0, 'I(5, 1, \'Elapsed Time\', \'00:01:01\', 1, \'Average memory/process\', \'775 MB\', 1, \'Max memory/process\', \'775 MB\', 2, \'Max number of processes/frequency\', 1, false, 2, \'Total number of cores\', 4, false)', false, true)
			ProfileItem('Frequency Sweep', 0, 0, 0, 0, 0, 'I(2, 1, \'Elapsed Time\', \'00:00:29\', 1, \'Total Memory\', \'858 MB\')', false, true)
			ProfileFootnote('I(3, 2, \'Max solved tets\', 18166, false, 2, \'Max matrix size\', 109489, false, 1, \'Matrix bandwidth\', \'20.4\')', 0)
		$end 'ProfileGroup'
		ProfileFootnote('I(2, 1, \'Stop Time\', \'04/18/2026 19:41:22\', 1, \'Status\', \'Normal Completion\')', 0)
	$end 'ProfileGroup'
$end 'Profile'
