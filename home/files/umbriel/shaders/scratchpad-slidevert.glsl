// Vertical slide for scratchpad show/hide, inspired by Hyprland specialWorkspace slidevert.
vec4 animation(vec2 uv) {
    float visible = umbriel_direction > 0.0
        ? umbriel_clamped_progress
        : 1.0 - umbriel_clamped_progress;

    float travel = (1.0 - visible) * 0.12;
    vec2 sample_uv = vec2(uv.x, uv.y + travel);

    vec4 color = umbriel_sample(sample_uv);
    float fade = smoothstep(0.0, 0.4, visible);

    return vec4(color.rgb * fade, color.a * fade);
}
