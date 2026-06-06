$begin 'Profile'
	$begin 'ProfileGroup'
		MajorVer=2024
		MinorVer=2
		Name='Solution Process'
		$begin 'StartInfo'
			I(1, 'Start Time', '04/18/2026 19:33:52')
			I(1, 'Host', 'DESKTOP-SB5LH8U')
			I(1, 'Processor', '32')
			I(1, 'OS', 'NT 10.0')
			I(1, 'Product', 'HFSS Version 2024.2.0')
		$end 'StartInfo'
		$begin 'TotalInfo'
			I(1, 'Elapsed Time', '00:02:00')
			I(1, 'ComEngine Memory', '185 M')
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
		ProfileItem('Design Validation', 0, 0, 0, 0, 0, 'I(1, 0, \'Elapsed time : 00:00:00 , HFSS ComEngine Memory : 172 M\')', false, true)
		ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Perform full validations with standard port validations\')', false, true)
		ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'\')', false, true)
		$begin 'ProfileGroup'
			MajorVer=2024
			MinorVer=2
			Name='Initial Meshing'
			$begin 'StartInfo'
				I(1, 'Time', '04/18/2026 19:33:53')
			$end 'StartInfo'
			$begin 'TotalInfo'
				I(1, 'Elapsed Time', '00:00:01')
			$end 'TotalInfo'
			GroupOptions=4
			TaskDataOptions('CPU Time'=8, Memory=8, 'Real Time'=8)
			ProfileItem('Mesh', 0, 0, 0, 0, 34324, 'I(2, 1, \'Type\', \'Phi\', 2, \'Tetrahedra\', 722, false)', true, true)
			ProfileItem('Post', 0, 0, 0, 0, 36136, 'I(2, 2, \'Tetrahedra\', 722, false, 2, \'Cores\', 1, false)', true, true)
			ProfileItem('Lambda Refine', 0, 0, 0, 0, 31464, 'I(2, 2, \'Tetrahedra\', 3763, false, 2, \'Cores\', 1, false)', true, true)
			ProfileItem('Simulation Setup', 0, 0, 0, 0, 182796, 'I(1, 1, \'Disk\', \'0 Bytes\')', true, true)
			ProfileItem('Port Adapt', 0, 0, 0, 0, 195780, 'I(2, 2, \'Tetrahedra\', 3729, false, 1, \'Disk\', \'5.41 KB\')', true, true)
			ProfileItem('Port Refine', 0, 0, 0, 0, 25204, 'I(2, 2, \'Tetrahedra\', 4041, false, 2, \'Cores\', 1, false)', true, true)
		$end 'ProfileGroup'
		$begin 'ProfileGroup'
			MajorVer=2024
			MinorVer=2
			Name='Adaptive Meshing'
			$begin 'StartInfo'
				I(1, 'Time', '04/18/2026 19:33:54')
			$end 'StartInfo'
			$begin 'TotalInfo'
				I(1, 'Elapsed Time', '00:01:11')
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
					ProfileItem('Simulation Setup ', 0, 0, 0, 0, 212280, 'I(2, 2, \'Tetrahedra\', 3899, false, 1, \'Disk\', \'4.17 KB\')', true, false)
					ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Port 1 supports an additional propagating and/or slowly decaying mode whose attenuation is   3.039e-01 and propagation constant is   6.309e+02\')', false, true)
					ProfileItem('Matrix Assembly', 0, 0, 0, 0, 234540, 'I(3, 2, \'Tetrahedra\', 3899, false, 2, \'1 Triangles\', 86, false, 1, \'Disk\', \'0 Bytes\')', true, false)
					ProfileItem('Matrix Solve', 0, 0, 0, 0, 309292, 'I(5, 1, \'Type\', \'DCS\', 2, \'Cores\', 2, false, 2, \'Matrix size\', 23551, false, 3, \'Matrix bandwidth\', 18.6823, \'%5.1f\', 1, \'Disk\', \'2.22 KB\')', true, false)
					ProfileItem('Field Recovery', 0, 0, 0, 0, 309292, 'I(2, 2, \'Excitations\', 1, false, 1, \'Disk\', \'1.59 MB\')', true, false)
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
					ProfileItem('Simulation Setup ', 0, 0, 0, 0, 212268, 'I(2, 2, \'Tetrahedra\', 3899, false, 1, \'Disk\', \'4.17 KB\')', true, false)
					ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Port 1 supports an additional propagating and/or slowly decaying mode whose attenuation is   1.514e-01 and propagation constant is   1.838e+02\')', false, true)
					ProfileItem('Matrix Assembly', 0, 0, 0, 0, 234624, 'I(3, 2, \'Tetrahedra\', 3899, false, 2, \'1 Triangles\', 86, false, 1, \'Disk\', \'0 Bytes\')', true, false)
					ProfileItem('Matrix Solve', 0, 0, 0, 0, 310012, 'I(5, 1, \'Type\', \'DCS\', 2, \'Cores\', 2, false, 2, \'Matrix size\', 23551, false, 3, \'Matrix bandwidth\', 18.6823, \'%5.1f\', 1, \'Disk\', \'2.22 KB\')', true, false)
					ProfileItem('Field Recovery', 0, 0, 0, 0, 310012, 'I(2, 2, \'Excitations\', 1, false, 1, \'Disk\', \'1.59 MB\')', true, false)
				$end 'ProfileGroup'
				ProfileItem('Data Transfer', 0, 0, 0, 0, 178952, 'I(1, 0, \'Adaptive Pass 1\')', true, true)
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
				ProfileItem('Adaptive Refine', 0, 0, 0, 0, 28364, 'I(2, 2, \'Tetrahedra\', 5215, false, 2, \'Cores\', 1, false)', true, true)
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
					ProfileItem('Simulation Setup ', 0, 0, 0, 0, 215024, 'I(2, 2, \'Tetrahedra\', 5073, false, 1, \'Disk\', \'3.4 KB\')', true, false)
					ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Port 1 supports an additional propagating and/or slowly decaying mode whose attenuation is   3.039e-01 and propagation constant is   6.309e+02\')', false, true)
					ProfileItem('Matrix Assembly', 0, 0, 0, 0, 242968, 'I(3, 2, \'Tetrahedra\', 5073, false, 2, \'1 Triangles\', 86, false, 1, \'Disk\', \'6 Bytes\')', true, false)
					ProfileItem('Matrix Solve', 0, 0, 0, 0, 346772, 'I(5, 1, \'Type\', \'DCS\', 2, \'Cores\', 2, false, 2, \'Matrix size\', 30395, false, 3, \'Matrix bandwidth\', 18.9328, \'%5.1f\', 1, \'Disk\', \'27.9 KB\')', true, false)
					ProfileItem('Field Recovery', 0, 0, 0, 0, 346772, 'I(2, 2, \'Excitations\', 1, false, 1, \'Disk\', \'1.61 MB\')', true, false)
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
					ProfileItem('Simulation Setup ', 0, 0, 0, 0, 214832, 'I(2, 2, \'Tetrahedra\', 5073, false, 1, \'Disk\', \'3.4 KB\')', true, false)
					ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Port 1 supports an additional propagating and/or slowly decaying mode whose attenuation is   1.514e-01 and propagation constant is   1.838e+02\')', false, true)
					ProfileItem('Matrix Assembly', 0, 0, 0, 0, 241496, 'I(3, 2, \'Tetrahedra\', 5073, false, 2, \'1 Triangles\', 86, false, 1, \'Disk\', \'8 Bytes\')', true, false)
					ProfileItem('Matrix Solve', 0, 0, 0, 0, 347700, 'I(5, 1, \'Type\', \'DCS\', 2, \'Cores\', 2, false, 2, \'Matrix size\', 30395, false, 3, \'Matrix bandwidth\', 18.9328, \'%5.1f\', 1, \'Disk\', \'27.9 KB\')', true, false)
					ProfileItem('Field Recovery', 0, 0, 0, 0, 347700, 'I(2, 2, \'Excitations\', 1, false, 1, \'Disk\', \'1.61 MB\')', true, false)
				$end 'ProfileGroup'
				ProfileItem('Data Transfer', 0, 0, 0, 0, 179332, 'I(1, 0, \'Adaptive Pass 2\')', true, true)
				ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 3, \'Max Mag. Delta S\', 1.40462, \'%.5f\')', false, true)
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
				ProfileItem('Adaptive Refine', 0, 0, 0, 0, 29860, 'I(2, 2, \'Tetrahedra\', 6739, false, 2, \'Cores\', 1, false)', true, true)
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
					ProfileItem('Simulation Setup ', 0, 0, 0, 0, 218840, 'I(2, 2, \'Tetrahedra\', 6597, false, 1, \'Disk\', \'3.4 KB\')', true, false)
					ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Port 1 supports an additional propagating and/or slowly decaying mode whose attenuation is   3.039e-01 and propagation constant is   6.309e+02\')', false, true)
					ProfileItem('Matrix Assembly', 0, 0, 0, 0, 252252, 'I(3, 2, \'Tetrahedra\', 6597, false, 2, \'1 Triangles\', 86, false, 1, \'Disk\', \'0 Bytes\')', true, false)
					ProfileItem('Matrix Solve', 0, 0, 0, 0, 390656, 'I(5, 1, \'Type\', \'DCS\', 2, \'Cores\', 2, false, 2, \'Matrix size\', 39435, false, 3, \'Matrix bandwidth\', 19.2861, \'%5.1f\', 1, \'Disk\', \'36.5 KB\')', true, false)
					ProfileItem('Field Recovery', 0, 0, 0, 0, 390656, 'I(2, 2, \'Excitations\', 1, false, 1, \'Disk\', \'2.05 MB\')', true, false)
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
					ProfileItem('Simulation Setup ', 0, 0, 0, 0, 219100, 'I(2, 2, \'Tetrahedra\', 6597, false, 1, \'Disk\', \'3.4 KB\')', true, false)
					ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Port 1 supports an additional propagating and/or slowly decaying mode whose attenuation is   1.514e-01 and propagation constant is   1.838e+02\')', false, true)
					ProfileItem('Matrix Assembly', 0, 0, 0, 0, 253196, 'I(3, 2, \'Tetrahedra\', 6597, false, 2, \'1 Triangles\', 86, false, 1, \'Disk\', \'0 Bytes\')', true, false)
					ProfileItem('Matrix Solve', 0, 0, 0, 0, 390740, 'I(5, 1, \'Type\', \'DCS\', 2, \'Cores\', 2, false, 2, \'Matrix size\', 39435, false, 3, \'Matrix bandwidth\', 19.2861, \'%5.1f\', 1, \'Disk\', \'36.5 KB\')', true, false)
					ProfileItem('Field Recovery', 0, 0, 0, 0, 390740, 'I(2, 2, \'Excitations\', 1, false, 1, \'Disk\', \'2.05 MB\')', true, false)
				$end 'ProfileGroup'
				ProfileItem('Data Transfer', 0, 0, 0, 0, 177260, 'I(1, 0, \'Adaptive Pass 3\')', true, true)
				ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 3, \'Max Mag. Delta S\', 0.430185, \'%.5f\')', false, true)
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
				ProfileItem('Adaptive Refine', 0, 0, 0, 0, 31784, 'I(2, 2, \'Tetrahedra\', 8720, false, 2, \'Cores\', 1, false)', true, true)
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
					ProfileItem('Simulation Setup ', 0, 0, 0, 0, 223636, 'I(2, 2, \'Tetrahedra\', 8577, false, 1, \'Disk\', \'3.4 KB\')', true, false)
					ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Port 1 supports an additional propagating and/or slowly decaying mode whose attenuation is   3.039e-01 and propagation constant is   6.309e+02\')', false, true)
					ProfileItem('Matrix Assembly', 0, 0, 0, 0, 264668, 'I(3, 2, \'Tetrahedra\', 8577, false, 2, \'1 Triangles\', 87, false, 1, \'Disk\', \'73 Bytes\')', true, false)
					ProfileItem('Matrix Solve', 0, 0, 1, 0, 448976, 'I(5, 1, \'Type\', \'DCS\', 2, \'Cores\', 2, false, 2, \'Matrix size\', 51161, false, 3, \'Matrix bandwidth\', 19.5465, \'%5.1f\', 1, \'Disk\', \'47 KB\')', true, false)
					ProfileItem('Field Recovery', 0, 0, 0, 0, 448976, 'I(2, 2, \'Excitations\', 1, false, 1, \'Disk\', \'2.61 MB\')', true, false)
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
					ProfileItem('Simulation Setup ', 0, 0, 0, 0, 222964, 'I(2, 2, \'Tetrahedra\', 8577, false, 1, \'Disk\', \'3.4 KB\')', true, false)
					ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Port 1 supports an additional propagating and/or slowly decaying mode whose attenuation is   1.514e-01 and propagation constant is   1.838e+02\')', false, true)
					ProfileItem('Matrix Assembly', 0, 0, 0, 0, 263816, 'I(3, 2, \'Tetrahedra\', 8577, false, 2, \'1 Triangles\', 87, false, 1, \'Disk\', \'75 Bytes\')', true, false)
					ProfileItem('Matrix Solve', 0, 0, 0, 0, 449580, 'I(5, 1, \'Type\', \'DCS\', 2, \'Cores\', 2, false, 2, \'Matrix size\', 51161, false, 3, \'Matrix bandwidth\', 19.5465, \'%5.1f\', 1, \'Disk\', \'47 KB\')', true, false)
					ProfileItem('Field Recovery', 0, 0, 0, 0, 449580, 'I(2, 2, \'Excitations\', 1, false, 1, \'Disk\', \'2.61 MB\')', true, false)
				$end 'ProfileGroup'
				ProfileItem('Data Transfer', 0, 0, 0, 0, 177532, 'I(1, 0, \'Adaptive Pass 4\')', true, true)
				ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 3, \'Max Mag. Delta S\', 0.207976, \'%.5f\')', false, true)
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
				ProfileItem('Adaptive Refine', 0, 0, 0, 0, 34460, 'I(2, 2, \'Tetrahedra\', 11299, false, 2, \'Cores\', 1, false)', true, true)
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
					ProfileItem('Simulation Setup ', 0, 0, 0, 0, 229704, 'I(2, 2, \'Tetrahedra\', 11156, false, 1, \'Disk\', \'3.4 KB\')', true, false)
					ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Port 1 supports an additional propagating and/or slowly decaying mode whose attenuation is   3.039e-01 and propagation constant is   6.309e+02\')', false, true)
					ProfileItem('Matrix Assembly', 0, 0, 0, 0, 282532, 'I(3, 2, \'Tetrahedra\', 11156, false, 2, \'1 Triangles\', 87, false, 1, \'Disk\', \'0 Bytes\')', true, false)
					ProfileItem('Matrix Solve', 0, 0, 1, 0, 548844, 'I(5, 1, \'Type\', \'DCS\', 2, \'Cores\', 2, false, 2, \'Matrix size\', 66833, false, 3, \'Matrix bandwidth\', 19.8923, \'%5.1f\', 1, \'Disk\', \'62.4 KB\')', true, false)
					ProfileItem('Field Recovery', 0, 0, 0, 0, 548844, 'I(2, 2, \'Excitations\', 1, false, 1, \'Disk\', \'3.34 MB\')', true, false)
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
					ProfileItem('Simulation Setup ', 0, 0, 0, 0, 228836, 'I(2, 2, \'Tetrahedra\', 11156, false, 1, \'Disk\', \'3.4 KB\')', true, false)
					ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Port 1 supports an additional propagating and/or slowly decaying mode whose attenuation is   1.514e-01 and propagation constant is   1.838e+02\')', false, true)
					ProfileItem('Matrix Assembly', 0, 0, 0, 0, 282084, 'I(3, 2, \'Tetrahedra\', 11156, false, 2, \'1 Triangles\', 87, false, 1, \'Disk\', \'2 Bytes\')', true, false)
					ProfileItem('Matrix Solve', 0, 0, 1, 0, 548936, 'I(5, 1, \'Type\', \'DCS\', 2, \'Cores\', 2, false, 2, \'Matrix size\', 66833, false, 3, \'Matrix bandwidth\', 19.8923, \'%5.1f\', 1, \'Disk\', \'62.4 KB\')', true, false)
					ProfileItem('Field Recovery', 0, 0, 0, 0, 548936, 'I(2, 2, \'Excitations\', 1, false, 1, \'Disk\', \'3.34 MB\')', true, false)
				$end 'ProfileGroup'
				ProfileItem('Data Transfer', 0, 0, 0, 0, 177792, 'I(1, 0, \'Adaptive Pass 5\')', true, true)
				ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 3, \'Max Mag. Delta S\', 0.0380035, \'%.5f\')', false, true)
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
				ProfileItem('Adaptive Refine', 0, 0, 0, 0, 37256, 'I(2, 2, \'Tetrahedra\', 14525, false, 2, \'Cores\', 1, false)', true, true)
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
					ProfileItem('Simulation Setup ', 0, 0, 0, 0, 236324, 'I(2, 2, \'Tetrahedra\', 14381, false, 1, \'Disk\', \'3.4 KB\')', true, false)
					ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Port 1 supports an additional propagating and/or slowly decaying mode whose attenuation is   3.039e-01 and propagation constant is   6.309e+02\')', false, true)
					ProfileItem('Matrix Assembly', 0, 0, 0, 0, 305112, 'I(3, 2, \'Tetrahedra\', 14381, false, 2, \'1 Triangles\', 88, false, 1, \'Disk\', \'77 Bytes\')', true, false)
					ProfileItem('Matrix Solve', 1, 0, 1, 0, 661428, 'I(5, 1, \'Type\', \'DCS\', 2, \'Cores\', 2, false, 2, \'Matrix size\', 86423, false, 3, \'Matrix bandwidth\', 20.1448, \'%5.1f\', 1, \'Disk\', \'77.7 KB\')', true, false)
					ProfileItem('Field Recovery', 0, 0, 0, 0, 661428, 'I(2, 2, \'Excitations\', 1, false, 1, \'Disk\', \'4.26 MB\')', true, false)
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
					ProfileItem('Simulation Setup ', 0, 0, 0, 0, 236780, 'I(2, 2, \'Tetrahedra\', 14381, false, 1, \'Disk\', \'3.4 KB\')', true, false)
					ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Port 1 supports an additional propagating and/or slowly decaying mode whose attenuation is   1.514e-01 and propagation constant is   1.838e+02\')', false, true)
					ProfileItem('Matrix Assembly', 0, 0, 0, 0, 305124, 'I(3, 2, \'Tetrahedra\', 14381, false, 2, \'1 Triangles\', 88, false, 1, \'Disk\', \'78 Bytes\')', true, false)
					ProfileItem('Matrix Solve', 1, 0, 1, 0, 662520, 'I(5, 1, \'Type\', \'DCS\', 2, \'Cores\', 2, false, 2, \'Matrix size\', 86423, false, 3, \'Matrix bandwidth\', 20.1448, \'%5.1f\', 1, \'Disk\', \'77.7 KB\')', true, false)
					ProfileItem('Field Recovery', 0, 0, 0, 0, 662520, 'I(2, 2, \'Excitations\', 1, false, 1, \'Disk\', \'4.26 MB\')', true, false)
				$end 'ProfileGroup'
				ProfileItem('Data Transfer', 0, 0, 0, 0, 176904, 'I(1, 0, \'Adaptive Pass 6\')', true, true)
				ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 3, \'Max Mag. Delta S\', 0.0237806, \'%.5f\')', false, true)
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
				ProfileItem('Adaptive Refine', 0, 0, 0, 0, 41812, 'I(2, 2, \'Tetrahedra\', 18368, false, 2, \'Cores\', 1, false)', true, true)
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
					ProfileItem('Simulation Setup ', 0, 0, 0, 0, 244992, 'I(2, 2, \'Tetrahedra\', 18216, false, 1, \'Disk\', \'4.57 KB\')', true, false)
					ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Port 1 supports an additional propagating and/or slowly decaying mode whose attenuation is   3.039e-01 and propagation constant is   6.309e+02\')', false, true)
					ProfileItem('Matrix Assembly', 0, 0, 0, 0, 329960, 'I(3, 2, \'Tetrahedra\', 18216, false, 2, \'1 Triangles\', 93, false, 1, \'Disk\', \'226 Bytes\')', true, false)
					ProfileItem('Matrix Solve', 1, 0, 2, 0, 792932, 'I(5, 1, \'Type\', \'DCS\', 2, \'Cores\', 2, false, 2, \'Matrix size\', 109899, false, 3, \'Matrix bandwidth\', 20.383, \'%5.1f\', 1, \'Disk\', \'92.9 KB\')', true, false)
					ProfileItem('Field Recovery', 0, 0, 0, 0, 792932, 'I(2, 2, \'Excitations\', 1, false, 1, \'Disk\', \'5.33 MB\')', true, false)
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
					ProfileItem('Simulation Setup ', 0, 0, 0, 0, 244220, 'I(2, 2, \'Tetrahedra\', 18216, false, 1, \'Disk\', \'4.57 KB\')', true, false)
					ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Port 1 supports an additional propagating and/or slowly decaying mode whose attenuation is   1.514e-01 and propagation constant is   1.838e+02\')', false, true)
					ProfileItem('Matrix Assembly', 0, 0, 0, 0, 330440, 'I(3, 2, \'Tetrahedra\', 18216, false, 2, \'1 Triangles\', 93, false, 1, \'Disk\', \'227 Bytes\')', true, false)
					ProfileItem('Matrix Solve', 1, 0, 2, 0, 791272, 'I(5, 1, \'Type\', \'DCS\', 2, \'Cores\', 2, false, 2, \'Matrix size\', 109899, false, 3, \'Matrix bandwidth\', 20.383, \'%5.1f\', 1, \'Disk\', \'92.9 KB\')', true, false)
					ProfileItem('Field Recovery', 0, 0, 0, 0, 791272, 'I(2, 2, \'Excitations\', 1, false, 1, \'Disk\', \'5.33 MB\')', true, false)
				$end 'ProfileGroup'
				ProfileItem('Data Transfer', 0, 0, 0, 0, 177804, 'I(1, 0, \'Adaptive Pass 7\')', true, true)
				ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 3, \'Max Mag. Delta S\', 0.0219641, \'%.5f\')', false, true)
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
				ProfileItem('Adaptive Refine', 0, 0, 0, 0, 47732, 'I(2, 2, \'Tetrahedra\', 23837, false, 2, \'Cores\', 1, false)', true, true)
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
					ProfileItem('Simulation Setup ', 0, 0, 0, 0, 263768, 'I(2, 2, \'Tetrahedra\', 23679, false, 1, \'Disk\', \'7.87 KB\')', true, false)
					ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Port 1 supports an additional propagating and/or slowly decaying mode whose attenuation is   3.039e-01 and propagation constant is   6.309e+02\')', false, true)
					ProfileItem('Matrix Assembly', 0, 0, 1, 0, 370676, 'I(3, 2, \'Tetrahedra\', 23679, false, 2, \'1 Triangles\', 99, false, 1, \'Disk\', \'295 Bytes\')', true, false)
					ProfileItem('Matrix Solve', 3, 0, 6, 0, 995632, 'I(5, 1, \'Type\', \'DCS\', 2, \'Cores\', 2, false, 2, \'Matrix size\', 143361, false, 3, \'Matrix bandwidth\', 20.5821, \'%5.1f\', 1, \'Disk\', \'132 KB\')', true, false)
					ProfileItem('Field Recovery', 0, 0, 0, 0, 995632, 'I(2, 2, \'Excitations\', 1, false, 1, \'Disk\', \'6.93 MB\')', true, false)
				$end 'ProfileGroup'
				$begin 'ProfileGroup'
					MajorVer=2024
					MinorVer=2
					Name='Frequency - 8GHz'
					$begin 'StartInfo'
						I(0, 'DESKTOP-SB5LH8U')
					$end 'StartInfo'
					$begin 'TotalInfo'
						I(0, 'Elapsed time : 00:00:06')
					$end 'TotalInfo'
					GroupOptions=0
					TaskDataOptions('CPU Time'=8, 'Real Time'=8)
					ProfileItem('Simulation Setup ', 0, 0, 0, 0, 262708, 'I(2, 2, \'Tetrahedra\', 23679, false, 1, \'Disk\', \'7.87 KB\')', true, false)
					ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Port 1 supports an additional propagating and/or slowly decaying mode whose attenuation is   1.514e-01 and propagation constant is   1.838e+02\')', false, true)
					ProfileItem('Matrix Assembly', 0, 0, 1, 0, 369792, 'I(3, 2, \'Tetrahedra\', 23679, false, 2, \'1 Triangles\', 99, false, 1, \'Disk\', \'295 Bytes\')', true, false)
					ProfileItem('Matrix Solve', 4, 0, 6, 0, 994424, 'I(5, 1, \'Type\', \'DCS\', 2, \'Cores\', 2, false, 2, \'Matrix size\', 143361, false, 3, \'Matrix bandwidth\', 20.5821, \'%5.1f\', 1, \'Disk\', \'132 KB\')', true, false)
					ProfileItem('Field Recovery', 0, 0, 0, 0, 994424, 'I(2, 2, \'Excitations\', 1, false, 1, \'Disk\', \'6.93 MB\')', true, false)
				$end 'ProfileGroup'
				ProfileItem('Data Transfer', 0, 0, 0, 0, 176948, 'I(1, 0, \'Adaptive Pass 8\')', true, true)
				ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 3, \'Max Mag. Delta S\', 0.0223556, \'%.5f\')', false, true)
			$end 'ProfileGroup'
			ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'\')', false, true)
			$begin 'ProfileGroup'
				MajorVer=2024
				MinorVer=2
				Name='Adaptive Pass 9'
				$begin 'StartInfo'
					I(0, 'Multi-Frequency Adaptive Meshing')
				$end 'StartInfo'
				$begin 'TotalInfo'
					I(0, ' ')
				$end 'TotalInfo'
				GroupOptions=0
				TaskDataOptions('CPU Time'=8, Memory=8, 'Real Time'=8)
				ProfileItem('Adaptive Refine', 0, 0, 0, 0, 55540, 'I(2, 2, \'Tetrahedra\', 30947, false, 2, \'Cores\', 1, false)', true, true)
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
						I(0, 'Elapsed time : 00:00:08')
					$end 'TotalInfo'
					GroupOptions=0
					TaskDataOptions('CPU Time'=8, 'Real Time'=8)
					ProfileItem(' ', 0, 0, 0, 0, 0, 'I(1, 0, \'\')', false, true)
					ProfileItem('Simulation Setup ', 0, 0, 0, 0, 276932, 'I(2, 2, \'Tetrahedra\', 30784, false, 1, \'Disk\', \'7.87 KB\')', true, false)
					ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Port 1 supports an additional propagating and/or slowly decaying mode whose attenuation is   3.039e-01 and propagation constant is   6.309e+02\')', false, true)
					ProfileItem('Matrix Assembly', 0, 0, 1, 0, 415668, 'I(3, 2, \'Tetrahedra\', 30784, false, 2, \'1 Triangles\', 103, false, 1, \'Disk\', \'158 Bytes\')', true, false)
					ProfileItem('Matrix Solve', 6, 0, 10, 0, 1297692, 'I(5, 1, \'Type\', \'DCS\', 2, \'Cores\', 2, false, 2, \'Matrix size\', 186853, false, 3, \'Matrix bandwidth\', 20.7453, \'%5.1f\', 1, \'Disk\', \'171 KB\')', true, false)
					ProfileItem('Field Recovery', 0, 0, 0, 0, 1297692, 'I(2, 2, \'Excitations\', 1, false, 1, \'Disk\', \'8.97 MB\')', true, false)
				$end 'ProfileGroup'
				$begin 'ProfileGroup'
					MajorVer=2024
					MinorVer=2
					Name='Frequency - 8GHz'
					$begin 'StartInfo'
						I(0, 'DESKTOP-SB5LH8U')
					$end 'StartInfo'
					$begin 'TotalInfo'
						I(0, 'Elapsed time : 00:00:08')
					$end 'TotalInfo'
					GroupOptions=0
					TaskDataOptions('CPU Time'=8, 'Real Time'=8)
					ProfileItem('Simulation Setup ', 0, 0, 0, 0, 276724, 'I(2, 2, \'Tetrahedra\', 30784, false, 1, \'Disk\', \'7.87 KB\')', true, false)
					ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Port 1 supports an additional propagating and/or slowly decaying mode whose attenuation is   1.514e-01 and propagation constant is   1.838e+02\')', false, true)
					ProfileItem('Matrix Assembly', 0, 0, 1, 0, 415960, 'I(3, 2, \'Tetrahedra\', 30784, false, 2, \'1 Triangles\', 103, false, 1, \'Disk\', \'158 Bytes\')', true, false)
					ProfileItem('Matrix Solve', 6, 0, 10, 0, 1298296, 'I(5, 1, \'Type\', \'DCS\', 2, \'Cores\', 2, false, 2, \'Matrix size\', 186853, false, 3, \'Matrix bandwidth\', 20.7453, \'%5.1f\', 1, \'Disk\', \'171 KB\')', true, false)
					ProfileItem('Field Recovery', 0, 0, 0, 0, 1298296, 'I(2, 2, \'Excitations\', 1, false, 1, \'Disk\', \'8.97 MB\')', true, false)
				$end 'ProfileGroup'
				ProfileItem('Data Transfer', 0, 0, 0, 0, 176868, 'I(1, 0, \'Adaptive Pass 9\')', true, true)
				ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 3, \'Max Mag. Delta S\', 0.0053178, \'%.5f\')', false, true)
			$end 'ProfileGroup'
			ProfileFootnote('I(1, 0, \'Adaptive Passes converged\')', 0)
		$end 'ProfileGroup'
		$begin 'ProfileGroup'
			MajorVer=2024
			MinorVer=2
			Name='Frequency Sweep'
			$begin 'StartInfo'
				I(1, 'Time', '04/18/2026 19:35:06')
			$end 'StartInfo'
			$begin 'TotalInfo'
				I(1, 'Elapsed Time', '00:00:47')
			$end 'TotalInfo'
			GroupOptions=4
			TaskDataOptions('CPU Time'=8, Memory=8, 'Real Time'=8)
			ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 1, \'HPC\', \'Enabled\')', false, true)
			ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'\')', false, true)
			ProfileItem('Solution SParam_Sweep', 0, 0, 0, 0, 0, 'I(1, 0, \'Fast Sweep\')', false, true)
			ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'From 8 GHz to 21 GHz, 200 Steps\')', false, true)
			ProfileItem('Simulation Setup', 0, 0, 0, 0, 243228, 'I(1, 1, \'Disk\', \'0 Bytes\')', true, true)
			ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Port 1 supports an additional propagating and/or slowly decaying mode whose attenuation is   2.185e-01 and propagation constant is   4.185e+02\')', false, true)
			ProfileItem('Matrix Assembly', 1, 0, 1, 0, 501328, 'I(3, 2, \'Tetrahedra\', 30784, false, 2, \'1 Triangles\', 103, false, 1, \'Disk\', \'0 Bytes\')', true, true)
			ProfileItem('Matrix Solve', 44, 0, 57, 0, 1453084, 'I(6, 1, \'Type\', \'DCS\', 2, \'Cores\', 4, false, 2, \'Matrix size\', 186853, false, 3, \'Matrix bandwidth\', 20.7453, \'%5.1f\', 2, \'Reduced matrix size\', 31, false, 1, \'Disk\', \'89.6 MB\')', true, true)
			ProfileItem('Field Recovery', 0, 0, 0, 0, 1453084, 'I(2, 2, \'Excitations\', 1, false, 1, \'Disk\', \'8 MB\')', true, true)
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
			ProfileItem('Design Validation', 0, 0, 0, 0, 0, 'I(2, 1, \'Elapsed Time\', \'00:00:00\', 1, \'Total Memory\', \'172 MB\')', false, true)
			ProfileItem('Initial Meshing', 0, 0, 0, 0, 0, 'I(2, 1, \'Elapsed Time\', \'00:00:01\', 1, \'Total Memory\', \'226 MB\')', false, true)
			ProfileItem('Adaptive Meshing', 0, 0, 0, 0, 0, 'I(5, 1, \'Elapsed Time\', \'00:01:11\', 1, \'Average memory/process\', \'1.24 GB\', 1, \'Max memory/process\', \'1.24 GB\', 2, \'Max number of processes/frequency\', 1, false, 2, \'Total number of cores\', 4, false)', false, true)
			ProfileItem('Frequency Sweep', 0, 0, 0, 0, 0, 'I(2, 1, \'Elapsed Time\', \'00:00:47\', 1, \'Total Memory\', \'1.39 GB\')', false, true)
			ProfileFootnote('I(3, 2, \'Max solved tets\', 30784, false, 2, \'Max matrix size\', 186853, false, 1, \'Matrix bandwidth\', \'20.7\')', 0)
		$end 'ProfileGroup'
		ProfileFootnote('I(2, 1, \'Stop Time\', \'04/18/2026 19:35:53\', 1, \'Status\', \'Normal Completion\')', 0)
	$end 'ProfileGroup'
	$begin 'ProfileGroup'
		MajorVer=2024
		MinorVer=2
		Name='Solution Process'
		$begin 'StartInfo'
			I(1, 'Start Time', '04/18/2026 19:38:10')
			I(1, 'Host', 'DESKTOP-SB5LH8U')
			I(1, 'Processor', '32')
			I(1, 'OS', 'NT 10.0')
			I(1, 'Product', 'HFSS Version 2024.2.0')
		$end 'StartInfo'
		$begin 'TotalInfo'
			I(1, 'Elapsed Time', '00:00:00')
			I(1, 'ComEngine Memory', '173 M')
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
		ProfileItem('Design Validation', 0, 0, 0, 0, 0, 'I(1, 0, \'Elapsed time : 00:00:00 , HFSS ComEngine Memory : 172 M\')', false, true)
		ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Perform full validations with standard port validations\')', false, true)
		ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'\')', false, true)
		ProfileItem('', 0, 0, 0, 0, 0, 'I(1, 0, \'Adaptive Passes converged\')', false, true)
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
			ProfileItem('Design Validation', 0, 0, 0, 0, 0, 'I(2, 1, \'Elapsed Time\', \'00:00:00\', 1, \'Total Memory\', \'172 MB\')', false, true)
			ProfileItem('Initial Meshing', 0, 0, 0, 0, 0, 'I(2, 1, \'Elapsed Time\', \'00:00:00\', 1, \'Total Memory\', \'0 Bytes\')', false, true)
		$end 'ProfileGroup'
		ProfileFootnote('I(2, 1, \'Stop Time\', \'04/18/2026 19:38:10\', 1, \'Status\', \'Normal Completion\')', 0)
	$end 'ProfileGroup'
$end 'Profile'
