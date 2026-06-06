$begin 'Profile'
	$begin 'ProfileGroup'
		MajorVer=2024
		MinorVer=2
		Name='Solution Process'
		$begin 'StartInfo'
			I(1, 'Start Time', '04/18/2026 19:41:27')
			I(1, 'Host', 'DESKTOP-SB5LH8U')
			I(1, 'Processor', '32')
			I(1, 'OS', 'NT 10.0')
			I(1, 'Product', 'HFSS Version 2024.2.0')
		$end 'StartInfo'
		$begin 'TotalInfo'
			I(1, 'Elapsed Time', '00:01:23')
			I(1, 'ComEngine Memory', '180 M')
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
			ProfileItem('Machine', 0, 0, 0, 0, 0, 'I(5, 1, \'Name\', \'DESKTOP-SB5LH8U\', 1, \'Memory\', \'31.7 GB\', 3, \'RAM Limit\', 90, \'%f%%\', 2, \'Cores\', 4, false, 1, \'Free Disk Space\', \'262 GB\')', false, true)
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
				I(1, 'Time', '04/18/2026 19:41:27')
			$end 'StartInfo'
			$begin 'TotalInfo'
				I(1, 'Elapsed Time', '00:00:01')
			$end 'TotalInfo'
			GroupOptions=4
			TaskDataOptions('CPU Time'=8, Memory=8, 'Real Time'=8)
			ProfileItem('Mesh', 0, 0, 0, 0, 34204, 'I(2, 1, \'Type\', \'Phi\', 2, \'Tetrahedra\', 741, false)', true, true)
			ProfileItem('Post', 0, 0, 0, 0, 36052, 'I(2, 2, \'Tetrahedra\', 741, false, 2, \'Cores\', 1, false)', true, true)
			ProfileItem('Lambda Refine', 0, 0, 0, 0, 31512, 'I(2, 2, \'Tetrahedra\', 3805, false, 2, \'Cores\', 1, false)', true, true)
			ProfileItem('Simulation Setup', 0, 0, 0, 0, 183172, 'I(1, 1, \'Disk\', \'0 Bytes\')', true, true)
			ProfileItem('Port Adapt', 0, 0, 0, 0, 196324, 'I(2, 2, \'Tetrahedra\', 3770, false, 1, \'Disk\', \'5.49 KB\')', true, true)
			ProfileItem('Port Refine', 0, 0, 0, 0, 25360, 'I(2, 2, \'Tetrahedra\', 4105, false, 2, \'Cores\', 1, false)', true, true)
		$end 'ProfileGroup'
		$begin 'ProfileGroup'
			MajorVer=2024
			MinorVer=2
			Name='Adaptive Meshing'
			$begin 'StartInfo'
				I(1, 'Time', '04/18/2026 19:41:28')
			$end 'StartInfo'
			$begin 'TotalInfo'
				I(1, 'Elapsed Time', '00:00:38')
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
					ProfileItem('Simulation Setup ', 0, 0, 0, 0, 212248, 'I(2, 2, \'Tetrahedra\', 3963, false, 1, \'Disk\', \'4.17 KB\')', true, false)
					ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Port 1 supports an additional propagating and/or slowly decaying mode whose attenuation is   3.039e-01 and propagation constant is   6.309e+02\')', false, true)
					ProfileItem('Matrix Assembly', 0, 0, 0, 0, 234576, 'I(3, 2, \'Tetrahedra\', 3963, false, 2, \'1 Triangles\', 86, false, 1, \'Disk\', \'0 Bytes\')', true, false)
					ProfileItem('Matrix Solve', 0, 0, 0, 0, 309660, 'I(5, 1, \'Type\', \'DCS\', 2, \'Cores\', 2, false, 2, \'Matrix size\', 23851, false, 3, \'Matrix bandwidth\', 18.6331, \'%5.1f\', 1, \'Disk\', \'2.22 KB\')', true, false)
					ProfileItem('Field Recovery', 0, 0, 0, 0, 309660, 'I(2, 2, \'Excitations\', 1, false, 1, \'Disk\', \'1.61 MB\')', true, false)
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
					ProfileItem('Simulation Setup ', 0, 0, 0, 0, 212812, 'I(2, 2, \'Tetrahedra\', 3963, false, 1, \'Disk\', \'4.17 KB\')', true, false)
					ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Port 1 supports an additional propagating and/or slowly decaying mode whose attenuation is   1.514e-01 and propagation constant is   1.838e+02\')', false, true)
					ProfileItem('Matrix Assembly', 0, 0, 0, 0, 235632, 'I(3, 2, \'Tetrahedra\', 3963, false, 2, \'1 Triangles\', 86, false, 1, \'Disk\', \'0 Bytes\')', true, false)
					ProfileItem('Matrix Solve', 0, 0, 0, 0, 310168, 'I(5, 1, \'Type\', \'DCS\', 2, \'Cores\', 2, false, 2, \'Matrix size\', 23851, false, 3, \'Matrix bandwidth\', 18.6331, \'%5.1f\', 1, \'Disk\', \'2.22 KB\')', true, false)
					ProfileItem('Field Recovery', 0, 0, 0, 0, 310168, 'I(2, 2, \'Excitations\', 1, false, 1, \'Disk\', \'1.61 MB\')', true, false)
				$end 'ProfileGroup'
				ProfileItem('Data Transfer', 0, 0, 0, 0, 179752, 'I(1, 0, \'Adaptive Pass 1\')', true, true)
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
				ProfileItem('Adaptive Refine', 0, 0, 0, 0, 28792, 'I(2, 2, \'Tetrahedra\', 5299, false, 2, \'Cores\', 1, false)', true, true)
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
					ProfileItem('Simulation Setup ', 0, 0, 0, 0, 215484, 'I(2, 2, \'Tetrahedra\', 5154, false, 1, \'Disk\', \'3.78 KB\')', true, false)
					ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Port 1 supports an additional propagating and/or slowly decaying mode whose attenuation is   3.039e-01 and propagation constant is   6.309e+02\')', false, true)
					ProfileItem('Matrix Assembly', 0, 0, 0, 0, 243364, 'I(3, 2, \'Tetrahedra\', 5154, false, 2, \'1 Triangles\', 89, false, 1, \'Disk\', \'158 Bytes\')', true, false)
					ProfileItem('Matrix Solve', 0, 0, 0, 0, 351684, 'I(5, 1, \'Type\', \'DCS\', 2, \'Cores\', 2, false, 2, \'Matrix size\', 30759, false, 3, \'Matrix bandwidth\', 18.8918, \'%5.1f\', 1, \'Disk\', \'28.2 KB\')', true, false)
					ProfileItem('Field Recovery', 0, 0, 0, 0, 351684, 'I(2, 2, \'Excitations\', 1, false, 1, \'Disk\', \'1.64 MB\')', true, false)
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
					ProfileItem('Simulation Setup ', 0, 0, 0, 0, 215524, 'I(2, 2, \'Tetrahedra\', 5154, false, 1, \'Disk\', \'3.78 KB\')', true, false)
					ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Port 1 supports an additional propagating and/or slowly decaying mode whose attenuation is   1.514e-01 and propagation constant is   1.838e+02\')', false, true)
					ProfileItem('Matrix Assembly', 0, 0, 0, 0, 242736, 'I(3, 2, \'Tetrahedra\', 5154, false, 2, \'1 Triangles\', 89, false, 1, \'Disk\', \'158 Bytes\')', true, false)
					ProfileItem('Matrix Solve', 0, 0, 0, 0, 350172, 'I(5, 1, \'Type\', \'DCS\', 2, \'Cores\', 2, false, 2, \'Matrix size\', 30759, false, 3, \'Matrix bandwidth\', 18.8918, \'%5.1f\', 1, \'Disk\', \'28.2 KB\')', true, false)
					ProfileItem('Field Recovery', 0, 0, 0, 0, 350172, 'I(2, 2, \'Excitations\', 1, false, 1, \'Disk\', \'1.64 MB\')', true, false)
				$end 'ProfileGroup'
				ProfileItem('Data Transfer', 0, 0, 0, 0, 181360, 'I(1, 0, \'Adaptive Pass 2\')', true, true)
				ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 3, \'Max Mag. Delta S\', 1.08882, \'%.5f\')', false, true)
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
				ProfileItem('Adaptive Refine', 0, 0, 0, 0, 29924, 'I(2, 2, \'Tetrahedra\', 6847, false, 2, \'Cores\', 1, false)', true, true)
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
					ProfileItem('Simulation Setup ', 0, 0, 0, 0, 220288, 'I(2, 2, \'Tetrahedra\', 6702, false, 1, \'Disk\', \'3.78 KB\')', true, false)
					ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Port 1 supports an additional propagating and/or slowly decaying mode whose attenuation is   3.039e-01 and propagation constant is   6.309e+02\')', false, true)
					ProfileItem('Matrix Assembly', 0, 0, 0, 0, 254280, 'I(3, 2, \'Tetrahedra\', 6702, false, 2, \'1 Triangles\', 89, false, 1, \'Disk\', \'0 Bytes\')', true, false)
					ProfileItem('Matrix Solve', 0, 0, 0, 0, 398484, 'I(5, 1, \'Type\', \'DCS\', 2, \'Cores\', 2, false, 2, \'Matrix size\', 40073, false, 3, \'Matrix bandwidth\', 19.3147, \'%5.1f\', 1, \'Disk\', \'37.6 KB\')', true, false)
					ProfileItem('Field Recovery', 0, 0, 0, 0, 398484, 'I(2, 2, \'Excitations\', 1, false, 1, \'Disk\', \'2.08 MB\')', true, false)
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
					ProfileItem('Simulation Setup ', 0, 0, 0, 0, 220320, 'I(2, 2, \'Tetrahedra\', 6702, false, 1, \'Disk\', \'3.78 KB\')', true, false)
					ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Port 1 supports an additional propagating and/or slowly decaying mode whose attenuation is   1.514e-01 and propagation constant is   1.838e+02\')', false, true)
					ProfileItem('Matrix Assembly', 0, 0, 0, 0, 254468, 'I(3, 2, \'Tetrahedra\', 6702, false, 2, \'1 Triangles\', 89, false, 1, \'Disk\', \'0 Bytes\')', true, false)
					ProfileItem('Matrix Solve', 0, 0, 0, 0, 398996, 'I(5, 1, \'Type\', \'DCS\', 2, \'Cores\', 2, false, 2, \'Matrix size\', 40073, false, 3, \'Matrix bandwidth\', 19.3147, \'%5.1f\', 1, \'Disk\', \'37.6 KB\')', true, false)
					ProfileItem('Field Recovery', 0, 0, 0, 0, 398996, 'I(2, 2, \'Excitations\', 1, false, 1, \'Disk\', \'2.08 MB\')', true, false)
				$end 'ProfileGroup'
				ProfileItem('Data Transfer', 0, 0, 0, 0, 177928, 'I(1, 0, \'Adaptive Pass 3\')', true, true)
				ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 3, \'Max Mag. Delta S\', 0.113454, \'%.5f\')', false, true)
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
				ProfileItem('Adaptive Refine', 0, 0, 0, 0, 31948, 'I(2, 2, \'Tetrahedra\', 8860, false, 2, \'Cores\', 1, false)', true, true)
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
					ProfileItem('Simulation Setup ', 0, 0, 0, 0, 224076, 'I(2, 2, \'Tetrahedra\', 8715, false, 1, \'Disk\', \'3.78 KB\')', true, false)
					ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Port 1 supports an additional propagating and/or slowly decaying mode whose attenuation is   3.039e-01 and propagation constant is   6.309e+02\')', false, true)
					ProfileItem('Matrix Assembly', 0, 0, 0, 0, 266268, 'I(3, 2, \'Tetrahedra\', 8715, false, 2, \'1 Triangles\', 89, false, 1, \'Disk\', \'0 Bytes\')', true, false)
					ProfileItem('Matrix Solve', 0, 0, 1, 0, 478024, 'I(5, 1, \'Type\', \'DCS\', 2, \'Cores\', 2, false, 2, \'Matrix size\', 52143, false, 3, \'Matrix bandwidth\', 19.6544, \'%5.1f\', 1, \'Disk\', \'48.3 KB\')', true, false)
					ProfileItem('Field Recovery', 0, 0, 0, 0, 478024, 'I(2, 2, \'Excitations\', 1, false, 1, \'Disk\', \'2.65 MB\')', true, false)
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
					ProfileItem('Simulation Setup ', 0, 0, 0, 0, 224476, 'I(2, 2, \'Tetrahedra\', 8715, false, 1, \'Disk\', \'3.78 KB\')', true, false)
					ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Port 1 supports an additional propagating and/or slowly decaying mode whose attenuation is   1.514e-01 and propagation constant is   1.838e+02\')', false, true)
					ProfileItem('Matrix Assembly', 0, 0, 0, 0, 267196, 'I(3, 2, \'Tetrahedra\', 8715, false, 2, \'1 Triangles\', 89, false, 1, \'Disk\', \'0 Bytes\')', true, false)
					ProfileItem('Matrix Solve', 0, 0, 1, 0, 477452, 'I(5, 1, \'Type\', \'DCS\', 2, \'Cores\', 2, false, 2, \'Matrix size\', 52143, false, 3, \'Matrix bandwidth\', 19.6544, \'%5.1f\', 1, \'Disk\', \'48.3 KB\')', true, false)
					ProfileItem('Field Recovery', 0, 0, 0, 0, 477452, 'I(2, 2, \'Excitations\', 1, false, 1, \'Disk\', \'2.65 MB\')', true, false)
				$end 'ProfileGroup'
				ProfileItem('Data Transfer', 0, 0, 0, 0, 177876, 'I(1, 0, \'Adaptive Pass 4\')', true, true)
				ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 3, \'Max Mag. Delta S\', 0.0528966, \'%.5f\')', false, true)
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
				ProfileItem('Adaptive Refine', 0, 0, 0, 0, 34860, 'I(2, 2, \'Tetrahedra\', 11480, false, 2, \'Cores\', 1, false)', true, true)
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
					ProfileItem('Simulation Setup ', 0, 0, 0, 0, 229728, 'I(2, 2, \'Tetrahedra\', 11335, false, 1, \'Disk\', \'3.78 KB\')', true, false)
					ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Port 1 supports an additional propagating and/or slowly decaying mode whose attenuation is   3.039e-01 and propagation constant is   6.309e+02\')', false, true)
					ProfileItem('Matrix Assembly', 0, 0, 0, 0, 285416, 'I(3, 2, \'Tetrahedra\', 11335, false, 2, \'1 Triangles\', 89, false, 1, \'Disk\', \'0 Bytes\')', true, false)
					ProfileItem('Matrix Solve', 0, 0, 1, 0, 556796, 'I(5, 1, \'Type\', \'DCS\', 2, \'Cores\', 2, false, 2, \'Matrix size\', 68101, false, 3, \'Matrix bandwidth\', 19.9994, \'%5.1f\', 1, \'Disk\', \'63.5 KB\')', true, false)
					ProfileItem('Field Recovery', 0, 0, 0, 0, 556796, 'I(2, 2, \'Excitations\', 1, false, 1, \'Disk\', \'3.39 MB\')', true, false)
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
					ProfileItem('Simulation Setup ', 0, 0, 0, 0, 229536, 'I(2, 2, \'Tetrahedra\', 11335, false, 1, \'Disk\', \'3.78 KB\')', true, false)
					ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Port 1 supports an additional propagating and/or slowly decaying mode whose attenuation is   1.514e-01 and propagation constant is   1.838e+02\')', false, true)
					ProfileItem('Matrix Assembly', 0, 0, 0, 0, 283704, 'I(3, 2, \'Tetrahedra\', 11335, false, 2, \'1 Triangles\', 89, false, 1, \'Disk\', \'0 Bytes\')', true, false)
					ProfileItem('Matrix Solve', 0, 0, 1, 0, 556580, 'I(5, 1, \'Type\', \'DCS\', 2, \'Cores\', 2, false, 2, \'Matrix size\', 68101, false, 3, \'Matrix bandwidth\', 19.9994, \'%5.1f\', 1, \'Disk\', \'63.5 KB\')', true, false)
					ProfileItem('Field Recovery', 0, 0, 0, 0, 556580, 'I(2, 2, \'Excitations\', 1, false, 1, \'Disk\', \'3.39 MB\')', true, false)
				$end 'ProfileGroup'
				ProfileItem('Data Transfer', 0, 0, 0, 0, 177812, 'I(1, 0, \'Adaptive Pass 5\')', true, true)
				ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 3, \'Max Mag. Delta S\', 0.0377006, \'%.5f\')', false, true)
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
				ProfileItem('Adaptive Refine', 0, 0, 0, 0, 38084, 'I(2, 2, \'Tetrahedra\', 14886, false, 2, \'Cores\', 1, false)', true, true)
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
					ProfileItem('Simulation Setup ', 0, 0, 0, 0, 237072, 'I(2, 2, \'Tetrahedra\', 14741, false, 1, \'Disk\', \'3.78 KB\')', true, false)
					ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Port 1 supports an additional propagating and/or slowly decaying mode whose attenuation is   3.039e-01 and propagation constant is   6.309e+02\')', false, true)
					ProfileItem('Matrix Assembly', 0, 0, 0, 0, 307004, 'I(3, 2, \'Tetrahedra\', 14741, false, 2, \'1 Triangles\', 89, false, 1, \'Disk\', \'0 Bytes\')', true, false)
					ProfileItem('Matrix Solve', 1, 0, 2, 0, 667016, 'I(5, 1, \'Type\', \'DCS\', 2, \'Cores\', 2, false, 2, \'Matrix size\', 88957, false, 3, \'Matrix bandwidth\', 20.2926, \'%5.1f\', 1, \'Disk\', \'82.7 KB\')', true, false)
					ProfileItem('Field Recovery', 0, 0, 0, 0, 667016, 'I(2, 2, \'Excitations\', 1, false, 1, \'Disk\', \'4.37 MB\')', true, false)
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
					ProfileItem('Simulation Setup ', 0, 0, 0, 0, 237092, 'I(2, 2, \'Tetrahedra\', 14741, false, 1, \'Disk\', \'3.78 KB\')', true, false)
					ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Port 1 supports an additional propagating and/or slowly decaying mode whose attenuation is   1.514e-01 and propagation constant is   1.838e+02\')', false, true)
					ProfileItem('Matrix Assembly', 0, 0, 0, 0, 307872, 'I(3, 2, \'Tetrahedra\', 14741, false, 2, \'1 Triangles\', 89, false, 1, \'Disk\', \'0 Bytes\')', true, false)
					ProfileItem('Matrix Solve', 1, 0, 2, 0, 667496, 'I(5, 1, \'Type\', \'DCS\', 2, \'Cores\', 2, false, 2, \'Matrix size\', 88957, false, 3, \'Matrix bandwidth\', 20.2926, \'%5.1f\', 1, \'Disk\', \'82.7 KB\')', true, false)
					ProfileItem('Field Recovery', 0, 0, 0, 0, 667496, 'I(2, 2, \'Excitations\', 1, false, 1, \'Disk\', \'4.37 MB\')', true, false)
				$end 'ProfileGroup'
				ProfileItem('Data Transfer', 0, 0, 0, 0, 178028, 'I(1, 0, \'Adaptive Pass 6\')', true, true)
				ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 3, \'Max Mag. Delta S\', 0.0162741, \'%.5f\')', false, true)
			$end 'ProfileGroup'
			ProfileFootnote('I(1, 0, \'Adaptive Passes converged\')', 0)
		$end 'ProfileGroup'
		$begin 'ProfileGroup'
			MajorVer=2024
			MinorVer=2
			Name='Frequency Sweep'
			$begin 'StartInfo'
				I(1, 'Time', '04/18/2026 19:42:07')
			$end 'StartInfo'
			$begin 'TotalInfo'
				I(1, 'Elapsed Time', '00:00:42')
			$end 'TotalInfo'
			GroupOptions=4
			TaskDataOptions('CPU Time'=8, Memory=8, 'Real Time'=8)
			ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 1, \'HPC\', \'Enabled\')', false, true)
			ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'\')', false, true)
			ProfileItem('Solution SParam_Sweep', 0, 0, 0, 0, 0, 'I(1, 0, \'Fast Sweep\')', false, true)
			ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'From 8 GHz to 21 GHz, 200 Steps\')', false, true)
			ProfileItem('Simulation Setup', 0, 0, 0, 0, 204244, 'I(1, 1, \'Disk\', \'0 Bytes\')', true, true)
			ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Port 1 supports an additional propagating and/or slowly decaying mode whose attenuation is   2.185e-01 and propagation constant is   4.185e+02\')', false, true)
			ProfileItem('Matrix Assembly', 0, 0, 0, 0, 330228, 'I(3, 2, \'Tetrahedra\', 14741, false, 2, \'1 Triangles\', 89, false, 1, \'Disk\', \'0 Bytes\')', true, true)
			ProfileItem('Matrix Solve', 41, 0, 42, 0, 764704, 'I(6, 1, \'Type\', \'DCS\', 2, \'Cores\', 4, false, 2, \'Matrix size\', 88957, false, 3, \'Matrix bandwidth\', 20.2926, \'%5.1f\', 2, \'Reduced matrix size\', 55, false, 1, \'Disk\', \'76.7 MB\')', true, true)
			ProfileItem('Field Recovery', 0, 0, 0, 0, 764704, 'I(2, 2, \'Excitations\', 1, false, 1, \'Disk\', \'3.91 MB\')', true, true)
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
			ProfileItem('Initial Meshing', 0, 0, 0, 0, 0, 'I(2, 1, \'Elapsed Time\', \'00:00:01\', 1, \'Total Memory\', \'227 MB\')', false, true)
			ProfileItem('Adaptive Meshing', 0, 0, 0, 0, 0, 'I(5, 1, \'Elapsed Time\', \'00:00:38\', 1, \'Average memory/process\', \'652 MB\', 1, \'Max memory/process\', \'652 MB\', 2, \'Max number of processes/frequency\', 1, false, 2, \'Total number of cores\', 4, false)', false, true)
			ProfileItem('Frequency Sweep', 0, 0, 0, 0, 0, 'I(2, 1, \'Elapsed Time\', \'00:00:42\', 1, \'Total Memory\', \'747 MB\')', false, true)
			ProfileFootnote('I(3, 2, \'Max solved tets\', 14741, false, 2, \'Max matrix size\', 88957, false, 1, \'Matrix bandwidth\', \'20.3\')', 0)
		$end 'ProfileGroup'
		ProfileFootnote('I(2, 1, \'Stop Time\', \'04/18/2026 19:42:50\', 1, \'Status\', \'Normal Completion\')', 0)
	$end 'ProfileGroup'
$end 'Profile'
