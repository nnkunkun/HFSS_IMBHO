function data = read_hfss_csv(filename)
    try
        opts = detectImportOptions(filename, 'VariableNamingRule', 'preserve');
        data = readtable(filename, opts);
        if isempty(data)
            data = table();
            return;
        end

        original_names = string(data.Properties.VariableNames);
        normalized_names = normalize_column_names(original_names);
        data.Properties.VariableNames = matlab.lang.makeUniqueStrings(cellstr(normalized_names));

        data = convert_units_if_needed(data);
    catch ME
        fprintf('Failed to read HFSS CSV %s: %s\n', filename, ME.message);
        data = table();
    end
end

function normalized_names = normalize_column_names(column_names)
    normalized_names = strings(size(column_names));

    for idx = 1:numel(column_names)
        raw_name = column_names(idx);
        key = lower(regexprep(raw_name, '[^a-zA-Z0-9]+', ''));

        if contains(key, 'peakrealizedgain')
            normalized_names(idx) = "PeakRealizedGain_dBi";
        elseif contains(key, 'peakgain')
            normalized_names(idx) = "PeakGain_dBi";
        elseif contains(key, 'fronttobackratio')
            normalized_names(idx) = "FrontToBackRatio_dB";
        elseif contains(key, 'gaintotal')
            normalized_names(idx) = "Gain_dBi";
        elseif contains(key, 'gain') && contains(key, 'db')
            normalized_names(idx) = "Gain_dBi";
        elseif contains(key, 'drivert1drivert1') || contains(key, 's11') || contains(key, 'st11')
            normalized_names(idx) = "S11_dB";
        elseif contains(key, 'st') && contains(key, '11')
            normalized_names(idx) = "S11_dB";
        elseif contains(key, 'theta')
            normalized_names(idx) = "Theta_deg";
        elseif contains(key, 'phi')
            normalized_names(idx) = "Phi_deg";
        elseif contains(key, 'freq')
            normalized_names(idx) = "Freq_GHz";
        else
            normalized_names(idx) = matlab.lang.makeValidName(raw_name);
        end
    end
end

function data = convert_units_if_needed(data)
    if ismember('Freq_GHz', data.Properties.VariableNames)
        freq = data.Freq_GHz;
        if isnumeric(freq) && ~isempty(freq)
            finite_freq = freq(isfinite(freq));
            if ~isempty(finite_freq) && max(abs(finite_freq)) > 1.0e6
                data.Freq_GHz = freq ./ 1.0e9;
            end
        end
    end

    if ismember('Theta_deg', data.Properties.VariableNames)
        data.Theta_deg = convert_angle_column(data.Theta_deg);
    end

    if ismember('Phi_deg', data.Properties.VariableNames)
        data.Phi_deg = convert_angle_column(data.Phi_deg);
    end
end

function angle_deg = convert_angle_column(angle_values)
    angle_deg = angle_values;
    if ~isnumeric(angle_values) || isempty(angle_values)
        return;
    end

    finite_values = angle_values(isfinite(angle_values));
    if isempty(finite_values)
        return;
    end

    if max(abs(finite_values)) <= (2 * pi + 1e-6)
        angle_deg = rad2deg(angle_values);
    end
end
